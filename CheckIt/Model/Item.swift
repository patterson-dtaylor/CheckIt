//
//  Item.swift
//  CheckIt
//
//  Created by Taylor Patterson on 5/11/20.
//  Copyright © 2020 Taylor Patterson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var timeStamp: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
