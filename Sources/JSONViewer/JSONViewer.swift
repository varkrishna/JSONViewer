import SwiftUI

public struct JSONViewer: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    private let rootNode: JSONNode
    private var initialNodeExpandStategy: InitialNodeExpandStrategy = .root
    
    public init(rootNode: JSONNode, initialNodeExpandStategy: InitialNodeExpandStrategy = .root) {
        self.rootNode = rootNode
        self.initialNodeExpandStategy = initialNodeExpandStategy
        self._fontConfiguration = Binding.constant(JSONViewerFontConfiguration())
    }
    
    public init(rootNode: JSONNode, fontConfiguration: Binding<JSONViewerFontConfiguration>, initialNodeExpandStategy: InitialNodeExpandStrategy = .root) {
        self.rootNode = rootNode
        self.initialNodeExpandStategy = initialNodeExpandStategy
        self._fontConfiguration = fontConfiguration
    }
    
    public var body: some View {
        HStack {
            VStack {
                ScrollView {
                    JSONNodeView(node: rootNode,
                                 level: 0,
                                 fontConfiguration: $fontConfiguration,
                                 initialNodeExpandStategy: self.initialNodeExpandStategy)
                }
                .scrollIndicators(.hidden)
                Spacer()
            }
            Spacer()
        }
    }
}
