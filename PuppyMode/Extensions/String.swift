//
//  String.swift
//  PuppyMode
//
//  Created by 이승준 on 2/8/25.
//

import Foundation

extension String {
    static func sliceText(string: String, max: Int) -> String {
        guard string.count > max else { return string }
        return String(string.prefix(max)) + "..."
    }
}

