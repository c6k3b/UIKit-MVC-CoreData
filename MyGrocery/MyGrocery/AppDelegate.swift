import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let coreDataManager = CoreDataManager()
        coreDataManager.initializeCoreDataStack()

        guard let navigationController = window?.rootViewController as? UINavigationController,
              let shoppingListTableVC = navigationController.viewControllers.first as? ShoppingListTableViewController
        else { fatalError("Root View Controller not found") }

        shoppingListTableVC.managedObjectContext = coreDataManager.managedObjectContext
        return true
    }
}
