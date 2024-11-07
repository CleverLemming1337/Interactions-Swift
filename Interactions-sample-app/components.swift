import Foundation
import Interactions

struct ComponentList: Scene {
    let title = "Components"
    var body: some Renderable {
        NavigationLink(key: .n1, label: "Table", destination: TableDemo())
        NavigationLink(key: .n2, label: "Button", destination: ButtonDemo())
        NavigationLink(key: .n3, label: "TabView", destination: TabDemo())
        NavigationLink(key: .n4, label: "Alert", destination: AlertDemo())
    }
}

struct TableDemo: Scene {
    let title = "Table"
    let data = ["a", "b", "c", "d"]
    var body: some Renderable {
        Table(data) {
            TableColumn<String>("Lowercase") { row in
                Text(row)
            }
            TableColumn<String>("Uppercase") { row in
                Text(row.uppercased())
            }
        }
    }
}

struct ButtonDemo: Scene {
    let title = "Button"

    var body: some Renderable {
        Button(.n1, "Press me with 1") {
            print("Button pressed")
        }
    }
}

struct TabDemo: Scene {
    let title = "Tab View"

    var body: some Renderable {
        TabView(tabs: [
            TabItem(title: "Tab A") {
                Text("Tab A")
            },
            TabItem(title: "Tab B") {
                Text("Tab B")
            }
        ])
    }
}

struct AlertDemo: Scene {
    let title = "Alert"
    let showAlert = StateItem(false)
    var body: some Renderable {
        Button(.cD, "Show alert") {
            showAlert.value = true
        }
        Text("\nThis text will be behind the alert.")
        Alert(title: "Alert title", text: "Here's to the crazy ones. The misfits. The rebels. The troublemakers. The round pegs in the square holes. The ones who see things differently. They’re not fond of rules. And they have no respect for the status quo. You can quote them, disagree with them, glorify or vilify them. But the only thing you can’t do is ignore them. Because they change things. They push the human race forward. And while some may see them as the crazy ones, We see genius. Because the people who are crazy enough to think they can change the world, Are the ones who do.", level: .info, isPresented: showAlert)
        
    }
}