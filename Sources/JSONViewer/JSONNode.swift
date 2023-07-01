//
//  File.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import Foundation

enum JSONNodeType {
    case object
    case array
    case other
}

var str = "".jsonNode

struct JSONNode: Identifiable, Hashable, Sequence {
    
    static func == (lhs: JSONNode, rhs: JSONNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(key: String, value: String, children: [JSONNode]) {
        self.key = key
        self.value = value
        self.children = children
    }
    
    let id = UUID()
    var key: String
    let value: String
    var children: [JSONNode]
    var type: JSONNodeType = .other
    
    var isExpandable: Bool {
        return !children.isEmpty
    }
    
    typealias Iterator = Array<JSONNode>.Iterator
    
    func makeIterator() -> Iterator {
        return children.makeIterator()
    }
}


