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

		let validResponses = response.passports.filter { $0.isValid }
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

		var isValid: Bool {
			return isPartOneValid && isPartTwoValid
		}

		var isPartOneValid: Bool {
			var requiredKinds = Set(Kind.allCases.filter { $0 != .cid })
			let included = Set(fields.keys.compactMap { Kind(rawValue: $0) })
			let subtracted = requiredKinds.subtracting(included)
			let isValid = subtracted.count == 0

			return isValid
		}

		var isPartTwoValid: Bool {
			let truths = fields.map { (key, value) -> Bool in
				guard let kind = Kind(rawValue: key) else { return false }

				let truth = kind.isValid(value: value)
				return truth
			}

			let isValid = !truths.contains(false)

			return isValid
		}
	}
}


extension PassportResponse.Passport {

	enum Kind: String, CaseIterable {
		case ecl, pid, eyr, hcl
		case byr, iyr, cid, hgt

		func isValid(value: String) -> Bool {
			switch self {
				case .ecl:
					return EyeColor(rawValue: value) != nil
				case .pid:
					return value.count == 9 && Int(value) != nil
				case .eyr:
					let number = Int(value) ?? 0
					return 2020...2030 ~= number
				case .hcl:
					return value.isHexColor
				case .byr:
					let number = Int(value) ?? 0
					return 1920...2002 ~= number
				case .iyr:
					let number = Int(value) ?? 0
					return 2010...2020 ~= number
				case .cid:
					return true
				case .hgt:
					if value.contains("in") {
						let numberString = value.replacingOccurrences(of: "in", with: "")
						let number = Int(numberString) ?? 0
						return 59...76 ~= number
					}

					if value.contains("cm") {
						let numberString = value.replacingOccurrences(of: "cm", with: "")
						let number = Int(numberString) ?? 0
						return 150...193 ~= number
					}

					return false
			}

			return true
		}
	}
}


enum EyeColor: String {
	case amb, blu, brn, gry, grn, hzl, oth
}


extension Array {
    public subscript(safeIndex index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }

        return self[index]
    }
}


extension String {
    var isHexColor: Bool {
        guard self.hasPrefix("#") else { return false }

        let characters = Array(self.dropFirst())
        let isHex = characters.map { $0.isHexDigit }
        let result = !isHex.contains(false)

        return result
    }
}
