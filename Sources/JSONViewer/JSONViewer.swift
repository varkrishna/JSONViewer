import SwiftUI

public struct JSONViewer: View {
    var rootNode: JSONNode
    
    public init(rootNode: JSONNode) {
        self.rootNode = rootNode
    }
    
    public var body: some View {
        HStack {
            VStack {
                ScrollView {
                    JSONNodeView(node: rootNode, level: 0, expanded: ["Root": true])
                }
                .scrollIndicators(.hidden)
                Spacer()
            }
            Spacer()
        }
    }
}
