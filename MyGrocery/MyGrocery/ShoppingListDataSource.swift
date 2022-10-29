import UIKit

class ShoppingListDataSource: NSObject {
    private var tableView: UITableView
    private var cellIdentifier: String
    private var shoppingListDataProvider: ShoppingListDataProvider

    init(tableView: UITableView, cellIdentifier: String, shoppingListDataProvider: ShoppingListDataProvider) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.shoppingListDataProvider = shoppingListDataProvider

        super.init()
        shoppingListDataProvider.delegate = self
    }
}

extension ShoppingListDataSource: ShoppingListDataProviderDelegate {
    func shoppingListDataProviderDidInsert(indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    func shoppingListDataProviderDidDelete(indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ShoppingListDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = shoppingListDataProvider.sections else { return 1 }
        return sections[section].numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let shoppingList = shoppingListDataProvider.objectAtIndex(at: indexPath)
        cell.textLabel?.text = shoppingList.title
        return cell
    }

    func tableView(
        _ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let shoppingList = shoppingListDataProvider.objectAtIndex(at: indexPath)
            shoppingListDataProvider.delete(shoppingList: shoppingList)
        }
        tableView.isEditing = false
    }
}
