//
//  File.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import Foundation

extension String {
    var jsonNode: JSONNode? {
        if let jsonData = self.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDict = jsonObject as? [String: Any] {
                    return self.createNode(key: "Root", value: jsonDict)
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    private func createNode(key: String, value: Any) -> JSONNode {
        var children: [JSONNode] = []
        var type: JSONNodeType = .other
        if let dict = value as? [String: Any] {
            type = .object
            for (key, value) in dict {
                children.append(createNode(key: key, value: value))
            }
        } else if let array = value as? [Any] {
            type = .array
            for (index, item) in array.enumerated() {
                children.append(createNode(key: "\(index)", value: item))
            }
        } else {
            children = []
        }
        let jsonNodeValue = "\(value)"
        var node = JSONNode(key: key, value: jsonNodeValue, children: children)
        node.type = type
        return node
    }
}
