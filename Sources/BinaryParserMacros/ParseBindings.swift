//
//  ParseBindings.swift
//
//
//  Created by alice on 2023-11-19.
//

import SwiftSyntax

func parseBindings(_ bindings: PatternBindingListSyntax, with attributes: Attributes) throws -> [Property] {
	try bindings
		.filter { $0.accessorBlock == nil } // filter out computed properties
		.map { try parseBinding($0, with: attributes) }
}

func parseBinding(_ binding: PatternBindingSyntax, with attributes: Attributes) throws -> Property {
	let name = binding.pattern.trimmedDescription
	
	let type =
		if let type = binding.typeAnnotation?.type.trimmedDescription {
			if attributes.ifCondition != nil {
				if type.hasSuffix("?") {
					String(type.dropLast())
				} else {
					throw PropertyParsingError.typeShouldBeOptional(for: name, type)
				}
			} else {
				type
			}
		} else if let initializer = binding.initializer {
			if initializer.value.is(StringLiteralExprSyntax.self) {
				"String"
			} else {
				throw PropertyParsingError.cannotInferType(for: name, initializer.trimmedDescription)
			}
		} else {
			fatalError("binding has no type")
		}
	
	let expected = binding.initializer?.value.trimmedDescription
	
	let size: Property.Size =
		if type.hasPrefix("[") && type.hasSuffix("]") {
			if let offsets = attributes.offsets {
				.offsets(offsets)
			} else if let count = attributes.count {
				.count(count)
			} else {
				throw PropertyParsingError.missingCount(for: name)
			}
		} else {
			.auto
		}

	if type == "Data" && attributes.length == nil {
		throw PropertyParsingError.missingLength(for: name)
	}
	
	if type == "[Data]" && attributes.endOffset == nil {
		throw PropertyParsingError.missingEndOffset(for: name)
	}
	
	if attributes.length != nil && !["String", "Data"].contains(type) {
		throw PropertyParsingError.lengthOnNonString(for: name, type)
	}
	
	return Property(
		name: name,
		type: type,
		size: size,
		padding: attributes.padding,
		offset: attributes.offset,
		expected: expected, 
		length: attributes.length,
		ifCondition: attributes.ifCondition,
		endOffset: attributes.endOffset
	)
}
