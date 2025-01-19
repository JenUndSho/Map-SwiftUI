//
//  AlertModel.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 18.07.2024.
//

import Foundation

struct AlertModel {

    var title: String
    var description: String

    init() {
        title = ""
        description = ""
    }

    init(title: String, description: String) {
        self.title = title
        self.description = description
    }

}
