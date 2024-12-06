public struct ForEach<T>: Interaction {
    let data: [T]
    let buildComponent: (T) -> Renderable
    let separator: String

    public var body: some Renderable {
        Text(wrapLinesByWords(text: data.map { buildComponent($0).render() }.joined(separator: separator), width: AppRenderer.shared.terminalSize.0*5))
    }

    public init(_ data: [T], separator: String = "\n", @InteractionBuilder _ buildComponent: @escaping (T) -> Renderable) {
        self.data = data
        self.separator = separator
        self.buildComponent = buildComponent
    }
}