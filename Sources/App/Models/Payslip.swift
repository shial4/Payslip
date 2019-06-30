//
//  Payslip.swift
//  App
//
//  Created by Szymon Lorenz on 30/6/19.
//

import Foundation
import Vapor

public struct Payslip: Content {
    public var totalWorkHours: Double
    public var eveningWorkHours: Double
    public var overtimeWorkHours: Double
    public var totalEarnings: Double
    var shifts: [Earnings]
    
    public init(_ work: Shifts) throws {
        self.shifts = try work.shifts.map({ try Earnings($0, wage: work.wageLevels, emplyee: work.employee) })
        self.totalWorkHours = shifts.reduce(Double(0), { $0 + Double($1.normalWorkMinutes) }) / 60.0
        self.eveningWorkHours = shifts.reduce(Double(0), { $0 + Double($1.workAtEveningMinutes) }) / 60.0
        self.overtimeWorkHours = shifts.reduce(Double(0), { $0 + Double($1.workOvertimeMinutes) }) / 60.0
        self.totalEarnings = shifts.reduce(Double(0), { $0 + $1.total })
    }
}
