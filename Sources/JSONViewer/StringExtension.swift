//
//  File.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import Foundation

public extension String {
    func jsonNode(sortingStrategy: SortingStrategy = .none) -> JSONNode? {
        if let jsonData = self.data(using: .utf8) {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDict = jsonObject as? [String: Any] {
                    return self.createNode(key: "Root", value: jsonDict, sortingStrategy: sortingStrategy)
                } else if let jsonArray = jsonObject as? [[String: Any]] {
                    return self.createNode(key: "Root", value: jsonArray, sortingStrategy: sortingStrategy)
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    private func createNode(key: String, value: Any, sortingStrategy: SortingStrategy) -> JSONNode {
        var children: [JSONNode] = []
        var type: JSONNodeType = .other
        if let dict = value as? [String: Any] {
            type = .object
            let sortedDict = SortedDictionary(source: dict, strategy: sortingStrategy)
            for (key, value) in sortedDict {
                children.append(createNode(key: key, value: value, sortingStrategy: sortingStrategy))
            }
        } else if let array = value as? [Any] {
            type = .array
            for (index, item) in array.enumerated() {
                children.append(createNode(key: "\(index)", value: item, sortingStrategy: sortingStrategy))
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
