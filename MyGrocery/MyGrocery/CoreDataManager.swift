import CoreData

class CoreDataManager {
    var managedObjectContext: NSManagedObjectContext?

    func initializeCoreDataStack() {
        guard let modelURL = Bundle.main.url(forResource: "MyGroceryDataModel", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL),
              let documentsURL = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first
        else { fatalError("Database could not be initialized") }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let storeURL = documentsURL.appendingPathComponent("MyGrocery.sqlite")
        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType

        try? persistentStoreCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL
        )

        managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        managedObjectContext?.persistentStoreCoordinator = persistentStoreCoordinator

        print(storeURL)
    }
}
