#!/usr/bin/env swift

import Foundation


main()


func main() {
	guard CommandLine.arguments.count == 2 else { print("missing input"); return }

	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let url = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: currentDirectoryURL)

	do {
		let input = try getInput(at: url)
		let tobo = Toboggan(input: input)
		tobo.printCheapModel()
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


class Toboggan {
	let input: [[String]]

	init(input: String) {
		var temp = [[String]]()
		let lines = input.components(separatedBy: "\n")

		lines.forEach {
			let characters = Array($0)
			let strings = characters.map { String($0) }
			temp.append(strings)
		}

		self.input = temp

		print(input)
	}

	func printCheapModel() {
		var trees = 0

		for (index, row) in input.enumerated() {
			if index == 0 { continue }
			if row.count < 3 { continue }

			let calculated = Int(index * 3)
			let column = calculated % row.count

			if row.indices.contains(column) {
				let value = row[column]
				if value == "#" {
					trees += 1
				}
			}
		}

		print("Count of trees: \(trees)")
	}
}
