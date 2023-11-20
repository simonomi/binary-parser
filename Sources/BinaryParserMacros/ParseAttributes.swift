//
//  ParseAttributes.swift
//
//
//  Created by alice on 2023-11-12.
//

import SwiftSyntax

enum ArgumentParsingError: Error {
	case invalidKeyPathBase(String?)
}

enum AttributeParsingError: Error {
	case duplicateAttribute(String)
	case paddingAndOffset
}

extension Attributes {
	mutating func parseAttribute(_ attribute: AttributeSyntax) throws {
		let attributeName = attribute.attributeName.trimmedDescription
		
		let keyPaths: [String : WritableKeyPath<Self, ValueOrProperty?>] = [
			"Padding": \.padding,
			"Offset": \.offset,
			"Count": \.count,
			"EndOffset": \.endOffset
		]
		
		if let keyPath = keyPaths[attributeName] {
			guard self[keyPath: keyPath] == nil else {
				throw AttributeParsingError.duplicateAttribute(attributeName)
			}
			
			guard let argument = attribute.arguments.flatMap(LabeledExprListSyntax.init)?.first else {
				fatalError("compiler bug: all attributes require an argument")
			}
			
			self[keyPath: keyPath] = try parseArgument(argument)
		} else if attributeName == "Offsets" {
			guard offsets == nil else {
				throw AttributeParsingError.duplicateAttribute("Offsets")
			}
			
			guard let arguments = attribute.arguments.flatMap(LabeledExprListSyntax.init) else {
				fatalError("compiler bug: @Offsets requires arguments")
			}
			
			offsets = try parseOffsets(arguments)
		} else if attributeName == "If" {
			guard ifCondition == nil else {
				throw AttributeParsingError.duplicateAttribute("Lengths")
			}
			
			guard let arguments = attribute.arguments.flatMap(LabeledExprListSyntax.init) else {
				fatalError("compiler bug: @If requires arguments")
			}
			
			ifCondition = try parseIfCondition(arguments)
		}
	}
}

func parseArgument(_ argument: LabeledExprSyntax) throws -> ValueOrProperty {
	let expression = argument.expression
	if let keyPath = KeyPathExprSyntax(expression) {
		let keyPathBase = keyPath.root?.trimmedDescription
		guard keyPathBase == "Self" else {
			throw ArgumentParsingError.invalidKeyPathBase(keyPathBase)
		}
		let path = keyPath.components.trimmedDescription
		let pathWithoutLeadingPeriod = String(path.dropFirst())
		return .property(pathWithoutLeadingPeriod)
	} else if let identifier = DeclReferenceExprSyntax(expression) {
		return .property(identifier.trimmedDescription)
	} else if let integer = IntegerLiteralExprSyntax(expression) {
		guard let value = Int(integer.trimmedDescription) else {
			fatalError("afaict, this can never fail?")
		}
		return .value(value)
	} else {
		fatalError("compiler bug: the argument must be an int or a keypath")
		// this could possibly happen if its an identifier? maybe a static let?
		// oh well idc that much
	}
}

func parseOffsets(_ arguments: LabeledExprListSyntax) throws -> Property.Size.Offsets {
	guard let keyPath = KeyPathExprSyntax(arguments.first!.expression) else {
		fatalError("compiler bug: @Offsets first argument must be a keypath")
	}
	
	let keyPathBase = keyPath.root?.trimmedDescription
	guard keyPathBase == "Self" else {
		throw ArgumentParsingError.invalidKeyPathBase(keyPathBase)
	}
	
	let path = keyPath.components.trimmedDescription
	let pathWithoutLeadingPeriod = String(path.dropFirst())
	
	switch arguments.count {
		case 1:
			return .givenByPath(pathWithoutLeadingPeriod)
		case 2:
			guard let subKeyPath = KeyPathExprSyntax(arguments.last!.expression) else {
				fatalError("compiler bug: @Offsets second argument must be a keypath")
			}
			
			let subPath = subKeyPath.trimmedDescription
			
			return .givenByPathAndSubpath(pathWithoutLeadingPeriod, subPath)
		default:
			fatalError("compiler bug: @Offsets should only have 1 or 2 arguments")
	}
}

func parseIfCondition(_ arguments: LabeledExprListSyntax) throws -> String {
	guard arguments.count == 2 else {
		fatalError("compiler bug: @If requires two arguments")
	}
	
	guard let keyPath = KeyPathExprSyntax(arguments.first!.expression) else {
		fatalError("compiler bug: @Offsets first argument must be a keypath")
	}
	
	let keyPathBase = keyPath.root?.trimmedDescription
	guard keyPathBase == "Self" else {
		throw ArgumentParsingError.invalidKeyPathBase(keyPathBase)
	}
	
	let path = keyPath.components.trimmedDescription
	let pathWithoutLeadingPeriod = String(path.dropFirst())
	
	let value = try parseArgument(arguments.last!)
	
	return "\(pathWithoutLeadingPeriod) == \(value.value)"
}
