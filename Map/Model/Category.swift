//
//  Category.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 18.06.2024.
//

import Foundation

struct Category: Identifiable {
    let id = UUID()
    let name: String

    init(name: String) {
        self.name = name
    }
}

extension Category: Equatable {
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
}
