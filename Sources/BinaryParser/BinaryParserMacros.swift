//
//  BinaryParserMacros.swift
//
//
//  Created by alice on 2023-11-12.
//

/// Documentation
@attached(extension, conformances: BinaryConvertible, names: named(init))
public macro BinaryConvertible() = #externalMacro(module: "BinaryParserMacros", type: "BinaryConvertibleMacro")

/// Documentation
@attached(peer)
public macro Padding(bytes: Int) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offset<S, T: BinaryInteger>(givenBy offset: KeyPath<S, T>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Count<T: BinaryInteger>(_ count: T) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Count<S, T: BinaryInteger>(givenBy count: KeyPath<S, T>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offsets<S, T: BinaryInteger>(givenBy offsets: KeyPath<S, [T]>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro Offsets<S, T, U: BinaryInteger>(givenBy offsets: KeyPath<S, [T]>, at subPath: KeyPath<T, U>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro If<S, T>(_ property: KeyPath<S, T>, is: T) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro EndOffset<T: BinaryInteger>(_ offset: T) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")

/// Documentation
@attached(peer)
public macro EndOffset<S, T: BinaryInteger>(givenBy offset: KeyPath<S, T>) = #externalMacro(module: "BinaryParserMacros", type: "EmptyMacro")
