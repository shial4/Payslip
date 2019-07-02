//
//  StringInitializable.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation

public protocol StringInitializable {
    init?(rawValue: String)
}

extension KeyedDecodingContainerProtocol {
    public func decodeUnstableOptional<T: Decodable & StringInitializable>(_ type: T.Type = T.self, forKey key: Key) throws -> T? {
        guard contains(key) else { return nil }
        guard !(try decodeNil(forKey: key)) else { return nil }
        
        if let string = try? decode(String.self, forKey: key) {
            guard let value = T.init(rawValue: string) else {
                throw DecodingError.dataCorruptedError(forKey: key,
                                                       in: self,
                                                       debugDescription: "Cannot converted to \(T.self)")
            }
            return value
        }
        return try decode(T.self, forKey: key)
    }

    public func decodeUnstable<T: Decodable & StringInitializable>(_ type: T.Type = T.self, forKey key: Key) throws -> T {
        if let string = try? decode(String.self, forKey: key) {
            guard let value = T.init(rawValue: string) else {
                throw DecodingError.dataCorruptedError(forKey: key,
                                                       in: self,
                                                       debugDescription: "Cannot converted to \(T.self)")
            }
            return value
        }
        return try decode(T.self, forKey: key)
    }
}

extension Int: StringInitializable {
    public init?(rawValue: String) {
        if let value = Int(rawValue) {
            self = value
            return
        } else if let value = Double(rawValue) {
            self = Int(value)
            return
        }
        return nil
    }
}

extension UInt: StringInitializable {
    public init?(rawValue: String) {
        if let value = UInt(rawValue) {
            self = value
            return
        } else if let value = Double(rawValue) {
            self = UInt(value)
            return
        }
        return nil
    }
}

extension Double: StringInitializable {
    public init?(rawValue: String) {
        guard let value = Double(rawValue) else {
            return nil
        }
        
        self = value
    }
}
