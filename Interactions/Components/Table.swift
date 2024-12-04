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
        for (rowIndex, row) in data.enumerated() {
            HStack {
                for (index, column) in columns.enumerated() {
                    Text(column.renderCell(row).render())
                        .align(width: UInt16(columns[index].title.count), alignment: column.alignment, excludedPadding: 1)
                        
                }
            }
            .background(rowIndex % 2 == 1 ? .color256(238) : .normal)
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
    let alignment: Alignment

    public var body: some Renderable {
        Text("")
    }

    public init(_ title: String, alignment: Alignment = .leading, _ renderCell: @escaping (T) -> Renderable) {
        self.title = title
        self.renderCell = renderCell
        self.alignment = alignment
    }
}
