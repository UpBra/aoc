#!/usr/bin/env swift

import Foundation


main()


func main() {
	guard CommandLine.arguments.count == 2 else { print("missing input"); return }

	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let url = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: currentDirectoryURL)

	do {
		let report = try exepenseReport(at: url)
		parseExenseReport(report)
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


func parseExenseReport(_ input: String) {
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
