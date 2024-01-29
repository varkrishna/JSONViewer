//
//  SwiftUIView.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import SwiftUI

public struct JSONNodeView: View {
    let node: JSONNode
    let level: Int
    private var initialNodeExpandStategy: InitialNodeExpandStrategy = .root
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    @State var expandedNodes: [String: Bool]
    
    internal init(node: JSONNode, level: Int, fontConfiguration: Binding<JSONViewerFontConfiguration>, initialNodeExpandStategy: InitialNodeExpandStrategy) {
        self.node = node
        self.level = level
        self._fontConfiguration = fontConfiguration
        self.initialNodeExpandStategy = initialNodeExpandStategy
        
        if initialNodeExpandStategy == .root && level == 0 {
            _expandedNodes = State(initialValue: ["Root": true])
        } else if initialNodeExpandStategy == .all {
            _expandedNodes = State(initialValue: [node.key: true])
        } else {
            _expandedNodes = State(initialValue: [:])
        }
    }
    
    public var body: some View {
        VStack {
            if node.isExpandable {
                ExpandableJSONNodeView(fontConfiguration: $fontConfiguration,
                                       node: node,
                                       level: level,
                                       isExpanded: isExpandedNode(),
                                       toggleActionHandler: toggleNodeState)
            } else {
                NonExpandableJSONNodeView(node: node, 
                                          fontConfiguration: fontConfiguration,
                                          level: level)
            }
        }
    }
    
    func toggleNodeState() {
        if let value = self.expandedNodes[node.key] {
            self.expandedNodes[node.key] = !value
        } else {
            self.expandedNodes[node.key] = true
       }
    }
    
    func isExpandedNode() -> Bool {
        guard let value = self.expandedNodes[node.key] else {
            return false
        }
        return value
    }

}

private struct ExpandableJSONNodeView: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    
    let node: JSONNode
    let level: Int
    let isExpanded: Bool
    let toggleActionHandler: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                    .frame(width: 32 * CGFloat(level))
                Button {
                    toggleActionHandler()
                } label: {
                    HStack {
                        nodeToggleButtonIcon()
                        expandableNodeTypeLabel()
                        Text(node.key)
                            .font(fontConfiguration.keyFont)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                JSONNodeSuccessorView(fontConfiguration: $fontConfiguration, node: node, level: level)
            }
        }
    }
    
    func nodeToggleButtonIcon() -> some View {
        if isExpanded {
            return Image(systemName: "minus.circle.fill")
                .imageScale(.large)
                .frame(width: 16, height: 16)
        } else {
            return Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .frame(width: 16, height: 16)
        }
    }
    
    func expandableNodeTypeLabel() -> some View {
        if node.type == .object {
            return AnyView(
                Image(systemName: "curlybraces")
                    .font(fontConfiguration.keyFont)
                    .frame(width: 16, height: 16)
            )
            
        } else if node.type == .array {
            return AnyView(
                Text("[ ]")
                    .font(fontConfiguration.keyFont)
                    .frame(width: 16, height: 16)
            )
        }
        return AnyView(EmptyView())
    }
}

private struct JSONNodeSuccessorView: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    
    let node: JSONNode
    let level: Int
    let initialNodeExpandStategy: InitialNodeExpandStrategy = .root
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ForEach(node.children) { childNode in
                HStack() {
                    JSONNodeView(node: childNode,
                                 level: level + 1,
                                 fontConfiguration: $fontConfiguration,
                                 initialNodeExpandStategy: self.initialNodeExpandStategy)
                }
            }
        }
    }
}

private struct NonExpandableJSONNodeView: View {
    let node: JSONNode
    let fontConfiguration: JSONViewerFontConfiguration
    let level: Int
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: (32 * CGFloat(level)) + 3)
            
            JSONNodeViewDot()
                .frame(maxHeight: .infinity, alignment: .top)
            
            JSONNodeViewData(node: node, fontConfiguration: fontConfiguration)
            Spacer()
        }
    }
}

private struct JSONNodeViewDot: View {
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 4)
            Circle()
                .fill(.white)
                .frame(width: 8, height: 8)
        }
    }
}

private struct JSONNodeViewData: View {
    let node: JSONNode
    let fontConfiguration: JSONViewerFontConfiguration
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\(node.key)")
                .font(fontConfiguration.keyFont)
            Text(":")
                .font(fontConfiguration.keyFont)
            Text("\(node.value)")
                .font(fontConfiguration.valueFont)
        }
    }
}
