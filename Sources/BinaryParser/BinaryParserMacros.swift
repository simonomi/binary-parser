//
//  BinaryParserMacros.swift
//
//
//  Created by alice on 2023-11-12.
//

/// Documentation
@attached(extension, conformances: BinaryConvertible, names: named(init))
public macro BinaryConvertible() = #externalMacro(module: "BinaryParserMacros", type: "BinaryConvertibleMacro")

public enum Operator<T> {
	case plus(T)
	case minus(T)
	case times(T)
	case dividedBy(T)
	case modulo(T)
}

/// Documentation
@attached(peer)
public macro Padding(bytes: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offset(_ offset: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offset<S, T: BinaryInteger>(givenBy offset: KeyPath<S, T>, _ operator: Operator<T>? = nil) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Count(_ count: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Count<S, T: BinaryInteger>(givenBy count: KeyPath<S, T>, _ operator: Operator<T>? = nil) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offsets<S, T: BinaryInteger>(givenBy offsets: KeyPath<S, [T]>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offsets<S, T, U: BinaryInteger>(givenBy offsets: KeyPath<S, [T]>, at subPath: KeyPath<T, U>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Length(_ length: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Length<S, T: BinaryInteger>(givenBy length: KeyPath<S, T>, _ operator: Operator<T>? = nil) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

public enum Comparison<T> {
	case equalTo(T)
	case greaterThan(T)
	case lessThan(T)
	case greaterThanOrEqualTo(T)
	case lessThanOrEqualTo(T)
}

/// Documentation
@attached(peer)
public macro If<S, T>(_ property: KeyPath<S, T>, is: Comparison<T>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro EndOffset(_ offset: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro EndOffset<S, T: BinaryInteger>(givenBy offset: KeyPath<S, T>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")
