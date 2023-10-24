import SwiftUI

public struct JSONViewer: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    private let rootNode: JSONNode
    private let expandedNodes: [String: Bool]
    
    public init(rootNode: JSONNode, isRootExpanded: Bool = true) {
        self.rootNode = rootNode
        self.expandedNodes = isRootExpanded ? ["Root": true] : [:]
        self._fontConfiguration = Binding.constant(JSONViewerFontConfiguration())
    }
    
    public init(rootNode: JSONNode, fontConfiguration: Binding<JSONViewerFontConfiguration>, isRootExpanded: Bool = true) {
        self.rootNode = rootNode
        self.expandedNodes = isRootExpanded ? ["Root": true] : [:]
        self._fontConfiguration = fontConfiguration
    }
    
    public var body: some View {
        HStack {
            VStack {
                ScrollView {
                    JSONNodeView(node: rootNode, 
                                 level: 0,
                                 expandedNodes: self.expandedNodes,
                                 fontConfiguration: $fontConfiguration)
                }
                .scrollIndicators(.hidden)
                Spacer()
            }
            Spacer()
        }
    }
}
