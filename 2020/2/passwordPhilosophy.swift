#!/usr/bin/env swift

import Foundation


main()


func main() {
	guard CommandLine.arguments.count == 2 else { print("missing input"); return }

	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let url = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: currentDirectoryURL)

	do {
		let input = try getInput(at: url)
		findValidPasswords(input: input)
	} catch {
		print("failed to get input")
	}
}


enum GenericError: Error {
	case failed
}


func getInput(at url: URL) throws -> String {
	let data = try Data(contentsOf: url)

	guard let result = String(data: data, encoding: .utf8) else { throw GenericError.failed }

	return result
}


func findValidPasswords(input: String) {
	let components = input.components(separatedBy: "\n")
	let passwordComponents = components.compactMap { Password(line: $0) }
	let validPassowrds = passwordComponents.compactMap { $0.isValid(policy: .one) ? $0 : nil }
	let count = validPassowrds.count

	print("Lines in file: \(components.count)")
	print("Password components: \(passwordComponents.count)")
	print("Found \(count) valid passwords")

	let validTwoPasswords = passwordComponents.compactMap { $0.isValid(policy: .two) ? $0 : nil }
	print("Found \(validTwoPasswords.count) valid two passwords")
}


extension String {

	func rangeComponents() -> (Int, Int)? {
		let components = self.components(separatedBy: "-")

		guard components.count == 2 else { return nil }
		guard let lower = Int(components[0]) else { return nil }
		guard let upper = Int(components[1]) else { return nil }

		return (lower, upper)
	}

	func specialCharacter() -> String? {
		let stringValue = self.replacingOccurrences(of: ":", with: "")
		return stringValue
	}
}


struct Password {

	enum Policy {
		case one, two
	}

	let lower: Int
	let upper: Int
	let special: String
	let value: String

	init?(line: String) {
		let components = line.components(separatedBy: " ")

		guard components.count == 3 else { print("invalid line"); return nil }

		let range = components[0]
		let special = components[1]
		let password = components[2]

		guard let rangeComponents = range.rangeComponents() else { return nil }
		guard let specialString = special.specialCharacter() else { return nil }

		self.lower = rangeComponents.0
		self.upper = rangeComponents.1
		self.special = specialString
		self.value = password
	}

	func isValid(policy: Policy) -> Bool {
		let characters = Array(value)

		switch policy {
			case .one:
				let counts = characters.reduce(into: [:]) { $0[$1, default: 0] += 1 }
				let character = Character(special)

				guard let occurrences = counts[character] else { return false }

				let result = occurrences <= upper && lower <= occurrences

				return result
			case .two:
				let firstIndex = lower - 1
				let secondIndex = upper - 1

				guard characters.indices.contains(secondIndex) else { return false }

				let firstIndexCharacter = String(characters[firstIndex])
				let isFirst = firstIndexCharacter == special

				let secondIndexCharacter = String(characters[secondIndex])
				let isSecond = secondIndexCharacter == special

				return isFirst != isSecond
		}
	}
}
