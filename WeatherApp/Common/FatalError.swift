//
//  FatalError.swift
//  WeatherApp
//
//  Created by Ilya Makarevich on 18.09.23.
//

import Foundation

public func fatalError<T>(_ message: @autoclosure () -> String = #function, file: StaticString = #file, line: UInt = #line) -> T {
    Swift.fatalError(message(), file: file, line: line)
}

public func preconditionFailure<T>(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) -> T {
    Swift.preconditionFailure(message(), file: file, line: line)
}
