#!/usr/bin/env swift

import Foundation


main()


func main() {
	guard CommandLine.arguments.count == 2 else { print("missing input"); return }

	let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
	let url = URL(fileURLWithPath: CommandLine.arguments[1], relativeTo: currentDirectoryURL)

	do {
		let input = try getInput(at: url)
		let response = PassportResponse(input: input)
		print(response)

		let validResponses = response.passports.filter { $0.isPartOneValid }
		print("Valid Responses: \(validResponses.count)")
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


class PassportResponse {
	let passports: [Passport]

	init(input: String) {
		let lines = input.components(separatedBy: "\n\n")
		let models = lines.compactMap { Passport(input: $0) }
		self.passports = models
	}
}


extension PassportResponse: CustomStringConvertible {

	var description: String {
		let mapped = passports.map { $0.description }
		let joined = mapped.joined(separator: "\n")
		return joined
	}
}


extension PassportResponse {

	struct Passport: CustomStringConvertible {
		let fields: [String: String]

		var description: String {
			return fields.description
		}

		init(input: String) {
			let normalized = input.replacingOccurrences(of: "\n", with: " ")
			let models = normalized.components(separatedBy: " ")
			var map = [String: String]()
			models.forEach {
				let parts = $0.components(separatedBy: ":")
				if let key = parts[safeIndex: 0], let value = parts[safeIndex: 1] {
					map[key] = value
				}
			}

			self.fields = map
		}

		var isPartOneValid: Bool {
			guard fields.keys.count >= 7 else { return false }
			guard let _ = fields[Kind.ecl.rawValue] else { return false }
			guard let _ = fields[Kind.pid.rawValue] else { return false }
			guard let _ = fields[Kind.eyr.rawValue] else { return false }
			guard let _ = fields[Kind.hcl.rawValue] else { return false }
			guard let _ = fields[Kind.byr.rawValue] else { return false }
			guard let _ = fields[Kind.iyr.rawValue] else { return false }
			guard let _ = fields[Kind.hgt.rawValue] else { return false }

			return true
		}
	}
}


extension PassportResponse.Passport {

	enum Kind: String, CaseIterable {
		case ecl, pid, eyr, hcl
		case byr, iyr, cid, hgt
	}
}


extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}
