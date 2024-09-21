//
//  SwiftUIView.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import SwiftUI

public enum JSONNodeActionEvents {
    case onDoubleTap(node: JSONNode)
}

enum JSONNodeActionInternalEvents {
    case onToggle(node: JSONNode)
    case onDoubleTap(node: JSONNode)
}

public struct JSONNodeView: View {
    let node: JSONNode
    let level: Int
    private var initialNodeExpandStategy: InitialNodeExpandStrategy = .root
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    @State var expandedNodes: [String: Bool]
    var actionHandler: ((JSONNodeActionEvents) -> Void)?
    
    internal init(node: JSONNode, level: Int, fontConfiguration: Binding<JSONViewerFontConfiguration>, initialNodeExpandStategy: InitialNodeExpandStrategy, actionHandler: ((JSONNodeActionEvents) -> Void)? = nil) {
        self.node = node
        self.level = level
        self._fontConfiguration = fontConfiguration
        self.initialNodeExpandStategy = initialNodeExpandStategy
        self.actionHandler = actionHandler
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
                ExpandableJSONNodeView(fontConfiguration: $fontConfiguration, node: node, level: level, isExpanded: isExpandedNode(), initialNodeExpandStategy: initialNodeExpandStategy) { event in
                    switch event {
                        case .onToggle( _):
                            toggleNodeState()
                        case .onDoubleTap(let node):
                            actionHandler?(.onDoubleTap(node: node))
                    }
                }
            } else {
                NonExpandableJSONNodeView(node: node, 
                                          fontConfiguration: fontConfiguration,
                                          level: level)
            }
        }
        .contextMenu(menuItems: {
            Button {
#if os(macOS)
                NSPasteboard.general.clearContents()
                if !node.isExpandable {
                    NSPasteboard.general.setString("{\"\(node.key)\": \"\(node.value ?? "")\"}", forType: .string)
                } else {
                    let jsonString = node.jsonString()
                    NSPasteboard.general.setString(jsonString, forType: .string)
                }
#elseif os(iOS)
                UIPasteboard.general.string = nil
                if !node.isExpandable {
                    UIPasteboard.general.string = "{\"\(node.key)\": \"\(node.value ?? "")\"}"
                } else {
                    let jsonString = node.jsonString()
                    UIPasteboard.general.string = jsonString
                }
#endif
            } label: {
                Text("Copy")
            }
        })
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
    var initialNodeExpandStategy: InitialNodeExpandStrategy
    let actionHandler: (JSONNodeActionInternalEvents) -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            HStack {
                Spacer()
                    .frame(width: 32 * CGFloat(level))
                HStack {
                    nodeToggleButtonIcon()
                        .onTapGesture {
                            actionHandler(.onToggle(node: node))
                        }
                    expandableNodeTypeLabel()
                    Text(node.key)
                        .font(fontConfiguration.keyFont)
                        .onTapGesture(count: 2, perform: {
                            actionHandler(.onDoubleTap(node: node))
                        })
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                JSONNodeSuccessorView(fontConfiguration: $fontConfiguration, node: node, level: level, initialNodeExpandStategy: self.initialNodeExpandStategy) { event in
                    switch event {
                        case .onDoubleTap(let node):
                            actionHandler(.onDoubleTap(node: node))
                    }
                }
            }
        }
    }
    
    func nodeToggleButtonIcon() -> some View {
        if isExpanded {
            return Image(systemName: "minus.circle.fill")
                .imageScale(.large)
                .font(fontConfiguration.keyFont)
                .frame(minWidth: 16, minHeight: 16)
        } else {
            return Image(systemName: "plus.circle.fill")
                .imageScale(.large)
                .font(fontConfiguration.keyFont)
                .frame(minWidth: 16, minHeight: 16)
        }
    }
    
    func expandableNodeTypeLabel() -> some View {
        if node.type == .object {
            return AnyView(
                Image(systemName: "curlybraces")
                    .font(fontConfiguration.keyFont)
                    .frame(minWidth: 16, minHeight: 16)
            )
            
        } else if node.type == .array {
            return AnyView(
                Text("[ ]")
                    .font(fontConfiguration.keyFont)
                    .frame(minWidth: 16, minHeight: 16)
            )
        }
        return AnyView(EmptyView())
    }
}

private struct JSONNodeSuccessorView: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    
    let node: JSONNode
    let level: Int
    let initialNodeExpandStategy: InitialNodeExpandStrategy
    let actionHandler: (JSONNodeActionEvents) -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ForEach(node.children) { childNode in
                HStack() {
                    JSONNodeView(node: childNode,
                                 level: level + 1,
                                 fontConfiguration: $fontConfiguration,
                                 initialNodeExpandStategy: self.initialNodeExpandStategy, actionHandler: self.actionHandler)
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
            
            JSONNodeViewDot(fontConfiguration: fontConfiguration)
                .frame(maxHeight: .infinity, alignment: .top)
            
            JSONNodeViewData(node: node, fontConfiguration: fontConfiguration)
            Spacer()
        }
    }
}

private struct JSONNodeViewDot: View {
    let fontConfiguration: JSONViewerFontConfiguration
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 4)
            Image(systemName: "circlebadge.fill")
                .font(fontConfiguration.keyFont)
                .frame(minWidth: 8, minHeight: 8)
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
