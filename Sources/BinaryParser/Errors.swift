//
//  Errors.swift
//
//
//  Created by alice on 2023-11-18.
//

public enum BinaryParserError: Error {
	case indexOutOfBounds(index: Int, expected: Range<Int>, for: Any.Type)
	case whileReading(Any.Type, any Error)
	case whileReading(Any.Type, count: Int, any Error)
	case whileReading(Any.Type, offsets: [Int], any Error)
}

public enum BinaryParserAssertionError<T>: Error {
	case unexpectedValue(actual: T, expected: T)
}
