//
//  Employee.swift
//  App
//
//  Created by Szymon Lorenz on 29/6/19.
//

import Foundation

public struct Employee: Decodable {
    public var name: String
    public var age: String
    public var casual: Bool
}
