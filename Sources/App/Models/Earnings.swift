//
//  Earnings.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation
import Vapor

public enum WeekDay: Int, Codable {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension WeekDay {
    public static func == (left: Int?, right: WeekDay) -> Bool {
        return left == right.rawValue
    }
    public static func != (left: Int?, right: WeekDay) -> Bool {
        return left != right.rawValue
    }
}

public enum EarningsError: Error {
    case wrongDates
    case missingBreakStartTime
    case missingBreakDuration
}

let nineHoursInMinutes = 540
let threeHoursInMinutes = 180

final class Earnings: Content {
    public enum CodingKeys: String, CodingKey {
        case workMinutes
        case workRate
        case workAtEveningMinutes
        case workAtEveningRate
        case workOvertimeMinutes
        case workOvertimeRate
        case total
        case startTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workMinutes = try container.decode(Int.self, forKey: .workMinutes)
        workRate = try container.decode(Double.self, forKey: .workRate)
        workAtEveningMinutes = try container.decode(Int.self, forKey: .workAtEveningMinutes)
        workAtEveningRate = try container.decode(Double.self, forKey: .workAtEveningRate)
        workOvertimeMinutes = try container.decode(Int.self, forKey: .workOvertimeMinutes)
        workOvertimeRate = try container.decode(Double.self, forKey: .workOvertimeRate)
        startTime = try container.decode(String.self, forKey: .startTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(normalWorkMinutes, forKey: .workMinutes)
        try container.encode(workRate, forKey: .workRate)
        try container.encode(workAtEveningMinutes, forKey: .workAtEveningMinutes)
        try container.encode(workAtEveningRate, forKey: .workAtEveningRate)
        try container.encode(workOvertimeMinutes, forKey: .workOvertimeMinutes)
        try container.encode(workOvertimeRate, forKey: .workOvertimeRate)
        try container.encode(total, forKey: .total)
        try container.encode(startTime, forKey: .startTime)
    }
    
    var normalWorkMinutes: Int {
        return workMinutes - max(workAtEveningMinutes, workOvertimeMinutes)
    }
    ///Indicate total time at work
    var workMinutes: Int = 0 {
        didSet {
            ///Hours beyond 9 hours of work (excluding breaks) are considered overtime.
            workOvertimeMinutes = workMinutes - nineHoursInMinutes
            //For hours worked on a Public Holiday the employee earns an additional loading of 150% (inclusive of the casual loading).
            if isHoliday {
                //For hours worked on a Public Holiday the employee earns an additional loading of 150% (inclusive of the casual loading).
                workRate = 1.5 * rate
            } else if weekday == .sunday {
                //For hours worked on a Sunday the employee earns an additional loading of 95% (inclusive of the casual loading).
                workRate = 0.95 * rate
            } else if weekday == .saturday {
                //For hours worked on a Saturday the employee earns an additonal loading of 50% (inclusive of the casual loading).
                workRate = 0.5 * rate
            } else {
                //If the employee is casual they earn an additional loading of 25% for every hour worked.
                workRate = rate * (isCasual ? 0.2 : 0.0)
            }
        }
    }
    var workRate: Double = 0
    ///Indicate time worked after 6PM which is included in total work time as well
    var workAtEveningMinutes: Int = 0 {
        didSet {
            if isHoliday {
                //For hours worked on a Public Holiday the employee earns an additional loading of 150% (inclusive of the casual loading).
                workAtEveningRate = 1.5 * rate
            } else if weekday == .sunday {
                //For hours worked on a Sunday the employee earns an additional loading of 95% (inclusive of the casual loading).
                workAtEveningRate = 0.95 * rate
            } else if weekday == .saturday {
                //For hours worked on a Saturday the employee earns an additonal loading of 50% (inclusive of the casual loading).
                workAtEveningRate = 0.5 * rate
            } else {
                //For hours worked after 6pm from Monday to Friday the employee earns an additional loading of 30% (inclusive of the casual loading).
                workAtEveningRate = 0.3 * rate
            }
        }
    }
    var workAtEveningRate: Double = 0
    ///Indicate overtime which is included in total time as well
    var workOvertimeRate: Double = 0
    var workOvertimeMinutes: Int = 0 {
        didSet {
            if isHoliday {
                //For overtime hours worked on a Public Holiday the employee earns an additional loading of 175% (inclusive of the casual loading).
                workOvertimeRate = 1.75 * rate
            } else {
                if weekday == .sunday {
                    //For overtime hours worked on a Sunday the employee earns an additional loading of 125%
                    workOvertimeRate = 1.25 * rate
                } else if workOvertimeMinutes > threeHoursInMinutes {
                    //For hours worked beyond 3 hours of overtime the employee earns an additional overtime loading of 125% (inclusive of the casual loading).
                    workOvertimeRate = Double((workOvertimeMinutes / threeHoursInMinutes)) * ((1.25 * rate) / (0.75 * rate))
                } else {
                    //For hours worked as overtime the employee earns an additional overtime loading of 75% (inclusive of the casual loading).
                    workOvertimeRate = 0.75 * rate
                }
            }
        }
    }
    var startTime: String
    var weekday: WeekDay?
    var isCasual: Bool = false
    var isHoliday: Bool = false
    var cribAllowance: Bool =  false
    var rate: Double = 0
    var total: Double {
        let normalWork = (Double(normalWorkMinutes) / 60.0) * (rate * workRate + rate)
        let eveningWork = (Double(workAtEveningMinutes) / 60.0) * (rate * workAtEveningRate + rate)
        let overTimeWork = (Double(workOvertimeMinutes) / 60.0) * (rate * workOvertimeRate + rate)
        return normalWork + eveningWork + overTimeWork
    }
    
    init(_ shift: Shift, wage: WageLevels, emplyee: Employee) throws {
        guard let start = shift.start.date(), let end = shift.end.date(),
            start < end else {
                throw EarningsError.wrongDates
        }
        if let weekDay = start.weekDay() {
            self.weekday =  WeekDay(rawValue: weekDay)
        }
        if let _ = shift.breakStart?.date(), shift.breakDurationMinutes == nil {
            throw EarningsError.missingBreakDuration
        }
        if let _ = shift.breakDurationMinutes, shift.breakStart == nil {
            throw EarningsError.missingBreakStartTime
        }
        self.startTime = start.toString()
        //If the employee is casual they earn an additional loading of 25% for every hour worked.
        self.rate = (wage.levels[shift.wageLevel] ?? 0)
        self.isCasual = emplyee.casual
        let breakStart = shift.breakStart?.date()
        let total = loadTotalWorkTime(prepareTimePoints(start: shift.start.date(), end: shift.end.date(), breakStart: breakStart, breakDuration: shift.breakDurationMinutes ?? 0))
        self.workMinutes = total.work
        self.cribAllowance = total.crib
        /*
         For hours worked after 6pm from Monday to Friday the employee earns an additional loading of 30% (inclusive of the casual loading).
         */
        if let start = shift.start.date(),
            start.weekDay() != WeekDay.saturday, start.weekDay() != WeekDay.sunday,
            let evening = start.setTo6PM(), let end = shift.end.date(), evening < end {
            //We do calculate evening hours which aren't overtime hours.
            self.workAtEveningMinutes = max(timeAfter6PM(prepareTimePoints(start: evening, end: shift.end.date(),
                                                                           breakStart: {
                                                                            if let time = breakStart, time >= evening, time < end  {
                                                                                return time
                                                                            }
                                                                            return nil
            }(),
                                                                           breakDuration: shift.breakDurationMinutes ?? 0)) - self.workOvertimeMinutes, 0)
        }
    }
    
    func prepareTimePoints(start: Date?, end: Date?, breakStart: Date?, breakDuration: Int) -> [Date?] {
        var timePoints = [start,end,breakStart]
        //We do not add break end if it did ended after the job finish.
        if let end = end, let breakEnd = breakStart?.add(interval: breakDuration, in: .minute),
            breakEnd < end {
            timePoints.append(breakEnd)
        }
        return timePoints
    }
    
    func loadTotalWorkTime(_ timePoints: [Date?]) -> (work: Int, crib: Bool) {
        let pointsSorted = timePoints.compactMap({$0}).sorted()
        var crib: Bool = false
        var workMinutes: Int = 0
        //Chunk size, we skip last element if chunk size is smaller. It doesn't change anything if this is the end work time.
        let chunk = 2
        pointsSorted.chunked(into: chunk).forEach { work in
            if work.count == chunk, let start = work.first, let end = work.last {
                let interval = Date.interval(from: start, to: end, in: .minute) ?? 0
                //If an employee works fore more than 5 hours without a break they are entitled to a crib allowance of 50% of thier base rate.
                crib = crib || interval > 5
                workMinutes += interval
            }
        }
        return (workMinutes, crib)
    }
    
    func timeAfter6PM(_ timePoints: [Date?]) -> Int {
        return loadTotalWorkTime(timePoints).work
    }
}
