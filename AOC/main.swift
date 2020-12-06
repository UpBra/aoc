//
// main.swift
// 
//

import ArgumentParser


struct aoc: ParsableCommand {
	@Option(name: .shortAndLong, help: "The advent day to execute. Example: \(Day.five.rawValue)")
	var day: Day

	@Argument(help: "Path to the input file.")
	var filePath: String

	mutating func run() throws {
		switch day {
		case .five:
			if let day5 = Input(filePath: filePath) {
				print(day5.input)
			}
		}
	}
}


aoc.main()


enum Day: Int, ExpressibleByArgument {
	case five = 5
}
