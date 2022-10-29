import CoreData

protocol ShoppingListDataProviderDelegate: AnyObject {
    func shoppingListDataProviderDidInsert(indexPath: IndexPath)
    func shoppingListDataProviderDidDelete(indexPath: IndexPath)
}

class ShoppingListDataProvider: NSObject {
    weak var delegate: ShoppingListDataProviderDelegate?
    var sections: [NSFetchedResultsSectionInfo]? { fetchedResultsController.sections }
    private var managedObjectContext: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<ShoppingList>

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        let request = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil
        )

        super.init()
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
    }

    func objectAtIndex(at indexPath: IndexPath) -> ShoppingList {
        fetchedResultsController.object(at: indexPath)
    }

    func delete(shoppingList: ShoppingList) {
        managedObjectContext.delete(shoppingList)
        try? managedObjectContext.save()
    }
}

extension ShoppingListDataProvider: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        if type == .insert, newIndexPath != nil {
            delegate?.shoppingListDataProviderDidInsert(indexPath: newIndexPath!)
        } else if type == .delete, indexPath != nil {
            delegate?.shoppingListDataProviderDidDelete(indexPath: indexPath!)
        }
    }
}
