//
//  WageLevels.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation

public struct WageLevels: Decodable {
    public var levels: [String:Double]
    
    struct WageKey: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        init?(intValue: Int) {
            self.stringValue = "\(intValue)";
            self.intValue = intValue
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: WageKey.self)
        var levels = [String: Double]()
        for key in container.allKeys {
            if let any = try container.decodeUnstable(Double.self, forKey: key) {
                levels[key.stringValue] = any
            }
        }
        self.levels = levels
    }
}
