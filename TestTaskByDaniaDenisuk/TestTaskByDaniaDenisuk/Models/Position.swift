//
//  Position.swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 27.09.2024.
//

import Foundation


struct PositionResponse: Decodable {
    let success: Bool
    let positions: [Position]
}


struct Position: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
}
