// —————————————————————————————————————————————————————————————————————————
//
// String+Extensions.swift
// Copyright © 2020 GLEESH. All rights reserved.
//
// —————————————————————————————————————————————————————————————————————————

import Foundation


extension String {
	var isHexColor: Bool {
		guard self.hasPrefix("#") else { return false }

		let characters = Array(self.dropFirst())
		let isHex = characters.map { $0.isHexDigit }
		let result = !isHex.contains(false)

		return result
	}
}
