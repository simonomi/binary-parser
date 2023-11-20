//
//  BinaryConvertible.swift
//
//
//  Created by alice on 2023-11-12.
//

public protocol BinaryConvertible {
	init(from data: MyData) throws
}

extension String: BinaryConvertible {
	public init(from data: MyData) throws {
		self = try data.read(String.self)
	}
}
