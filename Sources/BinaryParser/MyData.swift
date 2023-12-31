//
//  MyData.swift
//  
//
//  Created by alice on 2023-11-18.
//

import Foundation

/// Documentation
public class MyData {
	public typealias Byte = UInt8
	
	var bytes: [Byte]
	private var offset = 0
	
	public convenience init(_ data: Data) {
		self.init([Byte](data))
	}
	
	public init(_ bytes: [Byte]) {
		self.bytes = bytes
	}
	
	func canRead(bytes count: Int) -> Bool {
		offset + count <= bytes.endIndex
	}
	
	func canRead(until offset: Int) -> Bool {
		offset <= bytes.endIndex
	}
}

// MARK: read
extension MyData {
	/// Documentation
	public func read<T: BinaryConvertible>(_ type: T.Type) throws -> T {
		do {
			return try T(from: self)
		} catch {
			throw BinaryParserError.whileReading(T.self, error)
		}
	}
	
	/// Documentation
	public func read<T: BinaryConvertible, U: BinaryInteger>(
		_ type: [T].Type, count: U
	) throws -> [T] {
		let count = Int(count)
		do {
			return try (0..<count).map { _ in
				try read(T.self)
			}
		} catch {
			throw BinaryParserError.whileReading([T].self, count: count, error)
		}
	}
	
	/// Documentation
	public func read<T: BinaryConvertible, U: BinaryInteger>(
		_ type: [T].Type, offsets: [U], relativeTo baseOffset: Offset
	) throws -> [T] {
		let offsets = offsets.map { Int($0) + baseOffset.offest }
		do {
			return try offsets.map {
				offset = $0
				return try read(T.self)
			}
		} catch {
			throw BinaryParserError.whileReading([T].self, offsets: offsets, error)
		}
	}
}

// MARK: primitives
extension MyData {
	/// Documentation
	public func read<T: BinaryInteger>(_ type: T.Type) throws -> T {
		var output = T.zero
		let byteWidth = output.bitWidth / 8
		guard canRead(bytes: byteWidth) else {
			throw BinaryParserError.indexOutOfBounds(index: offset + byteWidth, expected: bytes.indices, for: T.self)
		}
		
		let range = offset..<(offset + byteWidth)
		
		for (index, byte) in bytes[range].enumerated() {
			output |= T(byte) << (index * 8)
		}
		
		defer { offset += byteWidth }
		return output
	}
	
	/// Documentation
	public func read<T: BinaryInteger, U: BinaryInteger>(
		_ type: [T].Type, count: U
	) throws -> [T] {
		let count = Int(count)
		do {
			return try (0..<count).map { _ in
				try read(T.self)
			}
		} catch {
			throw BinaryParserError.whileReading([T].self, count: count, error)
		}
	}
	
	enum StringParsingError: Error {
		case unterminated
		case invalidUTF8
	}
	
	/// Documentation
	public func read(_ type: String.Type) throws -> String {
		guard let endIndex = bytes[offset...].firstIndex(of: 0) else {
			throw StringParsingError.unterminated
		}
		guard canRead(until: endIndex) else {
			throw BinaryParserError.indexOutOfBounds(index: endIndex, expected: bytes.indices, for: String.self)
		}
		guard let string = String(data: Data(bytes[offset..<endIndex]), encoding: .utf8) else {
			throw StringParsingError.invalidUTF8
		}
		
		defer { offset += string.utf8.count + 1 }
		return string
	}
	
	/// Documentation
	public func read<T: BinaryInteger>(_ type: String.Type, length: T) throws -> String {
		let length = Int(length)
		
		guard canRead(bytes: length) else {
			throw BinaryParserError.indexOutOfBounds(index: offset + length, expected: bytes.indices, for: String.self)
		}
		guard let string = String(data: Data(bytes[offset..<(offset + length)]), encoding: .utf8) else {
			throw StringParsingError.invalidUTF8
		}
		
		defer { offset += length }
		return string
	}
	
	/// Documentation
	public func read<T: BinaryInteger>(
		_ type: Data.Type, length: T
	) throws -> Data {
		let length = Int(length)
		
		guard canRead(bytes: length) else {
			throw BinaryParserError.indexOutOfBounds(index: offset + length, expected: bytes.indices, for: Data.self)
		}
		
		defer { offset += length }
		return Data(bytes[offset..<(offset + length)])
	}
	
	/// Documentation
	public func read<T: BinaryInteger>(
		_ type: [Data].Type, offsets: [T], endOffset: T, relativeTo baseOffset: Offset
	) throws -> [Data] {
		let offsets = offsets.map { Int($0) + baseOffset.offest }
		let endOffset = Int(endOffset) + baseOffset.offest
		
		guard canRead(until: endOffset) else {
			throw BinaryParserError.indexOutOfBounds(index: endOffset, expected: bytes.indices, for: [Data].self)
		}
		
		let ranges = zip(offsets, offsets.dropFirst() + [endOffset])
		defer { offset = endOffset }
		return ranges.map { start, end in
			Data(bytes[start..<end])
		}
	}
}

// MARK: offset
extension MyData {
	public struct Offset {
		var offest: Int
		
		init(_ offest: Int) {
			self.offest = offest
		}
		
		public static func + <T: BinaryInteger>(lhs: Offset, rhs: T) -> Offset {
			Offset(lhs.offest + Int(rhs))
		}
	}
	
	/// Documentation
	public func placeMarker() -> Offset {
		Offset(offset)
	}
}

// MARK: jump
extension MyData {
	/// Documentation
	public func jump<T: BinaryInteger>(bytes: T) throws {
		offset += Int(bytes)
	}
	
	/// Documentation
	public func jump(to offset: Offset) throws {
		self.offset = offset.offest
	}
}
