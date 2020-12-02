#!/usr/bin/env swift

import Foundation


main()


struct Constant {
	static let magicNumber = Int(2020)
}


func main() {
	guard CommandLine.arguments.count == 2 else { print("missing input"); return }

	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let url = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: currentDirectoryURL)

	do {
		let report = try exepenseReport(at: url)
		partOne(expenseReport: report)
		partTwo(expenseReport: report)
	} catch {
		print("failed to get expense report")
	}
}


enum ExpenseReportError: Error {
	case failed
}


func exepenseReport(at url: URL) throws -> String {
	let data = try Data(contentsOf: url)

	guard let result = String(data: data, encoding: .utf8) else { throw ExpenseReportError.failed }

	return result
}


func partOne(expenseReport input: String) {
	let values = input.components(separatedBy: "\n")
	let intValues = values.compactMap { Int($0) }
	let validIntValues = intValues.filter { $0 < 2020 }
	var setValues = Set(validIntValues)

	for value in validIntValues {
		let success = 2020 - value
		guard setValues.contains(success) else { continue }

		setValues.remove(value)
		setValues.remove(success)

		print("\(value) + \(success) = 2020")

		let multiplied = success * value
		print("\(value) * \(success) = \(multiplied)")
	}
}


struct PartTwoAnswer: Hashable, CustomStringConvertible {
	let one: Int
	let two: Int
	let three: Int

	init(one: Int, two: Int, three: Int) {
		let ordered = [one, two, three].sorted()
		self.one = ordered[0]
		self.two = ordered[1]
		self.three = ordered[2]
	}

	var description: String {
		let components = [
			"\(one) + \(two) + \(three) = \(Constant.magicNumber)",
			"\(one) * \(two) * \(three) = \(one * two * three)"
		]
		let result = components.joined(separator: "\n")

		return result
	}
}


func partTwo(expenseReport input: String) {
	let values = input.components(separatedBy: "\n")
	let intValues = values.compactMap { Int($0) }

	var hashes = [Int: [Int]]()

	for value in intValues {
		let remainder = Constant.magicNumber - value
		let possibles = intValues.filter { $0 < remainder }
		hashes[value] = possibles
	}

	var answers = Set<PartTwoAnswer>()

	for (key, value) in hashes {
		for one in value {
			for two in value {
				if key + one + two == Constant.magicNumber {
					let answer = PartTwoAnswer(one: one, two: two, three: key)
					answers.insert(answer)
				}
			}
		}
	}

	for answer in answers {
		print(answer)
	}
}
