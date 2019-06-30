//
//  Shifts.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation

public struct Shifts: Decodable {
    public var employee: Employee
    public var wageLevels: WageLevels
    public var shifts: [Shift]
}

public struct Shift: Decodable {
    public var start: String
    public var end: String
    public var wageLevel: String
    public var breakStart: String?
    public var breakDurationMinutes: Int?
    
    enum ShiftKey: CodingKey {
        case start
        case end
        case wageLevel
        case breakStart
        case breakDurationMinutes
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ShiftKey.self)
        self.start = try container.decode(String.self, forKey: ShiftKey.start)
        self.end = try container.decode(String.self, forKey: ShiftKey.end)
        self.wageLevel = try container.decode(String.self, forKey: ShiftKey.wageLevel)
        if container.contains(ShiftKey.breakStart) {
            self.breakStart = try container.decode(String.self, forKey: ShiftKey.breakStart)
        }
        if container.contains(ShiftKey.breakDurationMinutes) {
            self.breakDurationMinutes = try container.decodeUnstable(Int.self, forKey: ShiftKey.breakDurationMinutes)
        }
    }
}
