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
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    @State var expandedNodes: [String: Bool]
    
    internal init(node: JSONNode, level: Int, expandedNodes: [String: Bool], fontConfiguration: Binding<JSONViewerFontConfiguration>) {
        self.node = node
        self.level = level
        self._expandedNodes = State(initialValue: expandedNodes)
        self._fontConfiguration = fontConfiguration
    }
    
    public var body: some View {
        VStack {
            if node.isExpandable {
                expandableNodeView()
            } else {
                nonExpandableNodeView()
            }
        }
    }
    
    func nonExpandableNodeView() -> some View {
        HStack {
            Spacer()
                .frame(width: 32 * CGFloat(level))
            Circle()
                .fill(.white)
                .frame(width: 8, height: 8)
            HStack(spacing: 0) {
                Text("\(node.key)")
                    .font(fontConfiguration.keyFont)
                Text(":")
                Text("\(node.value)")
                    .font(fontConfiguration.valueFont)
            }
            Spacer()
        }
    }
    
    func nodeToggleButtonIcon() -> some View {
        if self.expandedNodes[node.key] ?? false {
            Image(systemName: "minus.circle.fill")
                .imageScale(.large)
                .frame(width: 16, height: 16)
        } else {
            Image(systemName: "plus.circle.fill")
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
    
    func toggleNodeState() {
        if let value = self.expandedNodes[node.key] {
            self.expandedNodes[node.key] = !value
        } else {
            self.expandedNodes[node.key] = true
        }
    }
    
    func nodeSuccessorView() -> some View {
        VStack(alignment: .trailing) {
            ForEach(node.children) { childNode in
                HStack() {
                    JSONNodeView(node: childNode,
                                 level: level + 1,
                                 expandedNodes: [String : Bool](),
                                 fontConfiguration: self.$fontConfiguration)
                }
            }
        }
    }
    
    func expandableNodeView() -> some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                    .frame(width: 32 * CGFloat(level))
                Button {
                    toggleNodeState()
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
            
            if self.expandedNodes[node.key] ?? false {
                nodeSuccessorView()
            }
        }
    }
}
