// —————————————————————————————————————————————————————————————————————————
//
// Array+Extensions.swift
// Copyright © 2020 GLEESH. All rights reserved.
//
// —————————————————————————————————————————————————————————————————————————

import Foundation


extension Array {
	public subscript(safeIndex index: Int) -> Element? {
		guard index >= 0, index < endIndex else {
			return nil
		}

		return self[index]
	}
}


extension Array {
	func chunked(by chunkSize: Int) -> [[Element]] {
		return stride(from: 0, to: self.count, by: chunkSize).map {
			Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
		}
	}
}
