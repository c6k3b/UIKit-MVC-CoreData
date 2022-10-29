import UIKit
import CoreData

class ShoppingListTableViewController: UITableViewController {
    private var shoppingListDataProvider: ShoppingListDataProvider!
    private var shoppingListDataSource: ShoppingListDataSource!
    var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateShoppingList()
    }

    private func populateShoppingList() {
        shoppingListDataProvider = ShoppingListDataProvider(managedObjectContext: managedObjectContext)
        shoppingListDataSource = ShoppingListDataSource(
            tableView: tableView,
            cellIdentifier: "ShoppingListTableViewCell",
            shoppingListDataProvider: shoppingListDataProvider
        )
        tableView.dataSource = shoppingListDataSource
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = {
            let textField = {
                $0.placeholder = "Enter Shopping List"
                $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
                $0.leftViewMode = .always
                $0.delegate = self
                return $0
            }(UITextField(frame: $0.frame))

            $0.backgroundColor = .lightText
            $0.layer.backgroundColor = UIColor.white.cgColor
            $0.addSubview(textField)
            return $0
        }(UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)))

        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 44 }
}

extension ShoppingListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let managedObjectContext = managedObjectContext else { return false }
        let shoppingList = NSEntityDescription.insertNewObject(
            forEntityName: "ShoppingList", into: managedObjectContext
        ) as? ShoppingList

        shoppingList?.title = textField.text
        textField.text = nil
        try? managedObjectContext.save()

        return textField.resignFirstResponder()
    }
}
