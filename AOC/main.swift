// —————————————————————————————————————————————————————————————————————————
//
// main.swift
// Copyright © 2020 GLEESH. All rights reserved.
//
// —————————————————————————————————————————————————————————————————————————

import ArgumentParser


struct aoc: ParsableCommand {
	@Option(name: .shortAndLong, help: "The advent day to execute. Example: \(Day.five.rawValue)")
	var day: Day

	@Argument(help: "Path to the input file.")
	var filePath: String

	mutating func run() throws {
		guard let input = InputFile(filePath: filePath) else {
			throw GenericError.failed("Missing input file.")
		}

		switch day {
		case .five:
			let model = Day5(input: input)

			let highestID = model.highestID
			print("Highest seat number: \(highestID)")

			let missingID = model.missingID
			print("Missing ID: \(missingID)")
		}
	}
}


aoc.main()


enum Day: Int, ExpressibleByArgument {
	case five = 5
}
