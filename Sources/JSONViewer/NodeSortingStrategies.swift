//
//  File.swift
//  
//
//  Created by krishna varshney on 25/10/23.
//

import Foundation

public enum SortingStrategy {
    case ascending
    case descending
    case none
}

class SortedDictionary: Sequence, IteratorProtocol {
    private let source: Dictionary<String, Any>
    private let strategy: SortingStrategy
    private var idx = -1
    
    private lazy var sortedData: ([Dictionary<String, Any>.Element]) = {
        switch strategy {
        case .ascending:
            return source.sorted(by: { $0.key < $1.key })
        case .descending:
            return source.sorted(by: { $0.key > $1.key })
        case .none:
            return  source.map({$0})
        }
        
    }()
    
    internal init(source: Dictionary<String, Any>, strategy: SortingStrategy) {
        self.source = source
        self.strategy = strategy
    }
    
    func makeIterator() -> SortedDictionary {
        return self
    }
    
    func next() -> (String, Any)? {
        idx += 1
        guard sortedData.indices.contains(idx) else {
           return nil
        }
        return (sortedData[idx].key, sortedData[idx].value)
    }
}
