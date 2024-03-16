import SwiftUI

public struct JSONViewer: View {
    @Binding var fontConfiguration: JSONViewerFontConfiguration
    private let rootNode: JSONNode
    private var initialNodeExpandStategy: InitialNodeExpandStrategy = .root
    private var actionHandler: ((JSONNodeActionEvents) -> Void)? = nil
    
    public init(rootNode: JSONNode, initialNodeExpandStategy: InitialNodeExpandStrategy = .root, actionHandler: ((JSONNodeActionEvents) -> Void)? = nil) {
        self.rootNode = rootNode
        self.initialNodeExpandStategy = initialNodeExpandStategy
        self.actionHandler = actionHandler
        self._fontConfiguration = Binding.constant(JSONViewerFontConfiguration())
    }
    
    public init(rootNode: JSONNode, fontConfiguration: Binding<JSONViewerFontConfiguration>, initialNodeExpandStategy: InitialNodeExpandStrategy = .root, actionHandler: ((JSONNodeActionEvents) -> Void)? = nil) {
        self.rootNode = rootNode
        self.initialNodeExpandStategy = initialNodeExpandStategy
        self._fontConfiguration = fontConfiguration
        self.actionHandler = actionHandler
    }
    
    public var body: some View {
        HStack {
            VStack {
                ScrollView {
                    JSONNodeView(node: rootNode,
                                 level: 0,
                                 fontConfiguration: $fontConfiguration,
                                 initialNodeExpandStategy: self.initialNodeExpandStategy, actionHandler: self.actionHandler)
                }
                .scrollIndicators(.hidden)
                Spacer()
            }
            Spacer()
        }
    }
}
