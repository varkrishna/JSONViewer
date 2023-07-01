//
//  SwiftUIView.swift
//  
//
//  Created by Krishan Kumar Varshney on 01/07/23.
//

import SwiftUI

public struct JSONNodeView: View {
    var node: JSONNode
    var level: Int
    @State var expanded: [String: Bool]
    public var body: some View {
        VStack {
            if node.isExpandable {
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                            .frame(width: 32 * CGFloat(level))
                        Button {
                            if let value = self.expanded[node.key] {
                                self.expanded[node.key] = !value
                            } else {
                                self.expanded[node.key] = true
                            }
                        } label: {
                            HStack {
                                if self.expanded[node.key] ?? false {
                                    Image(systemName: "minus.circle.fill")
                                        .imageScale(.large)
                                        .frame(width: 16, height: 16)
                                } else {
                                    Image(systemName: "plus.circle.fill")
                                        .imageScale(.large)
                                        .frame(width: 16, height: 16)
                                }
                                
                                if node.type == .object {
                                    Image(systemName: "curlybraces")
                                        .frame(width: 16, height: 16)
                                } else if node.type == .array {
                                    Text("[ ]")
                                        .frame(width: 16, height: 16)
                                }
                                Text(node.key)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    .buttonStyle(PlainButtonStyle())
                    if self.expanded[node.key] ?? false {
                        VStack(alignment: .trailing) {
                            ForEach(node.children) { childNode in
                                HStack() {
                                    JSONNodeView(node: childNode, level: level + 1, expanded: [String : Bool]())
                                }
                            }
                        }
                    }
                }
            } else {
                HStack {
                    Spacer()
                        .frame(width: 32 * CGFloat(level))
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                    Text("\(node.key): \(node.value)")
                        .font(.headline)
                    Spacer()
                }
            }
        }
    }
}
