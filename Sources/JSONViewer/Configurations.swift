//
//  File.swift
//  
//
//  Created by krishna varshney on 24/10/23.
//

import Foundation
import SwiftUI

public struct JSONViewerFontConfiguration {
    let keyFont: Font
    let valueFont: Font
    
    public init(keyFont: Font, valueFont: Font) {
        self.keyFont = keyFont
        self.valueFont = valueFont
    }
    
    public init(with font: Font) {
        self.keyFont = font
        self.valueFont = font
    }
    
    public init() {
        self.init(with: .system(size: 14))
    }
    
}


public enum InitialNodeExpandStrategy {
    case none
    case root
    case all
    
//    case uptoLevel(Int)
//    case arrayUptoLevel(Int)
}
