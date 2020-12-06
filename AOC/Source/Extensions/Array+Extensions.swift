//
// Array+Extensions.swift
// Copyright © 2020 GLEESH. All rights reserved.
//

import Foundation


extension Array {
	public subscript(safeIndex index: Int) -> Element? {
		guard index >= 0, index < endIndex else {
			return nil
		}

		return self[index]
	}
}
