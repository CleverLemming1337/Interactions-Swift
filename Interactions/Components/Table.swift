import Foundation

public struct Table<T>: Interaction {
    let data: Array<T>
    let columns: [TableColumn<T>]

    public var body: some Renderable {
        HStack {
            for column in columns {
                Text(column.title)
                    .padding()
            }
        }
            .reversed()
        for row in data {
            HStack {
                for (index, column) in columns.enumerated() {
                    Text("\(centered: column.renderCell(row).render(), width: UInt16(columns[index].title.count))")
                        .padding()
                }
            }
        }
    }

    public init(_ data: Array<T>, @InteractionBuilder _ columns: () -> [Renderable]) {
        self.data = data
        var columnsResult = [TableColumn<T>]()
        for column in columns() {
            if let column = column as? TableColumn<T> {
                columnsResult.append(column)
            }
        }
        self.columns = columnsResult
    }
}

public struct TableColumn<T>: Interaction {
    let renderCell: (T) -> Renderable
    let title: String
    public var body: some Renderable {
        Text("")
    }

    public init(_ title: String, _ renderCell: @escaping (T) -> Renderable) {
        self.title = title
        self.renderCell = renderCell
    }
}