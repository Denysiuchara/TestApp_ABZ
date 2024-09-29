//
//  Data + append.swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 28.09.2024.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
