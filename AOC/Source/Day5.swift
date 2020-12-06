// —————————————————————————————————————————————————————————————————————————
//
// Day5.swift
// Copyright © 2020 GLEESH. All rights reserved.
//
// —————————————————————————————————————————————————————————————————————————

import Foundation


struct Day5 {
	let input: InputFile
	let contexts: [Context]

	init(input: InputFile) {
		self.input = input

		let lines = input.file.components(separatedBy: "\n")
		let normalizedLines = lines.filter { !$0.isEmpty }
		self.contexts = normalizedLines.compactMap { Context(seat: Array($0)) }
	}

	var highestID: Int {
		let seatNumbers = contexts.map { $0.id }
		let sorted = seatNumbers.sorted()
		let result = sorted.last ?? Int.max

		return result
	}

	var missingID: Int {
		let ids = contexts.map { $0.id }
		let sorted = ids.sorted()
		let idSet = Set(sorted)

		let first = sorted.first ?? 0
		let last = sorted.last ?? Int.max
		let allValues = Set(Array(first...last))

		let subtracted = allValues.subtracting(idSet)
		let result = subtracted.first ?? Int.max

		return result
	}
}


extension Day5 {

	enum Constant {
		static let rows = Array(0...127)
		static let columns = Array(0...7)
	}

	struct Context {
		let seat: [Character]

		var row: Int {
			let rowModifiers = Array(seat[0..<7])
			let final = rowModifiers.reduce(into: Constant.rows) { (result, character) in
				guard result.count > 1 else { return }

				let midpoint = result.count / 2
				let chunks = result.chunked(by: midpoint)

				if String(character) == "F" {
					result = chunks.first ?? result
				} else {
					result = chunks.last ?? result
				}
			}

			let result = final.first ?? Int.max

			return result
		}

		var column: Int {
			let columnModifiers = Array(seat[7...])
			let final = columnModifiers.reduce(into: Constant.columns) { (result, character) in
				let midpoint = result.count / 2
				let chunks = result.chunked(by: midpoint)

				if String(character) == "L" {
					result = chunks.first ?? result
				} else {
					result = chunks.last ?? result
				}
			}

			let result = final.first ?? Int.max

			return result
		}

		var id: Int {
			(row * 8) + column
		}
	}
}
