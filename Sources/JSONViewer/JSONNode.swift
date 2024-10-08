//
//  File.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import Foundation

public enum JSONNodeType {
    case object
    case array
    case other
}

public struct JSONNode: Identifiable, Hashable, Sequence {
    
    public static func == (lhs: JSONNode, rhs: JSONNode) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public init(key: String, value: String, children: [JSONNode]) {
        self.key = key
        self.value = value
        self.children = children
    }
    
    public let id = UUID()
    public var key: String
    public let value: String
    public var children: [JSONNode]
    public var type: JSONNodeType = .other
    
    public var isExpandable: Bool {
        return type != .other
    }
    
    public typealias Iterator = Array<JSONNode>.Iterator
    
    public func makeIterator() -> Iterator {
        return children.makeIterator()
    }
    
    func jsonString(isChild: Bool = false, isArrayItem: Bool = false) -> String {
        var result = ""
        if !isChild {
            result += "{"
        }
        if !isArrayItem {
            result += "\"\(key)\":"
        }
        if !children.isEmpty {
            if type == .object {
                result += "{"
                for child in children {
                    result += child.jsonString(isChild: true)
                    result += ","
                }
                result.removeLast()
                result += "}"
            } else {
                result += "["
                for child in children {
                    result += child.jsonString(isChild: true, isArrayItem: true)
                    result += ","
                }
                result.removeLast()
                result += "]"
            }
        }
        else if !value.isEmpty {
            result += "\"\(value)\""
        }
        
        if !isChild {
            result += "}"
        }
        
        return result
    }
}


