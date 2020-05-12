//
//  Category.swift
//  CheckIt
//
//  Created by Taylor Patterson on 5/11/20.
//  Copyright © 2020 Taylor Patterson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
}
