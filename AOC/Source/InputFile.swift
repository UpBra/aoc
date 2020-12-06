// —————————————————————————————————————————————————————————————————————————
//
//  InputFile.swift
//  Copyright © 2020 GLEESH. All rights reserved.
//
// —————————————————————————————————————————————————————————————————————————

import Foundation


struct InputFile {

	let file: String

	init?(filePath: String) {
		let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
		let url = URL(fileURLWithPath: filePath, relativeTo: currentDirectoryURL)

		guard let data = try? Data(contentsOf: url) else { return nil }
		guard let dataString = String(data: data, encoding: .utf8) else { return nil }

		self.file = dataString
	}
}
