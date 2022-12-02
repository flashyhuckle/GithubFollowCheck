import UIKit

final class FavoritesCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: FavoritesScreens = FavoritesScreens()
    private let presenter: UINavigationController
    
    //MARK: Child coordinators
    
    private var listCoordinator: ListCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    //MARK: Start
    
    func start() {
        let favoritesViewController = screens.createFavoritesViewController { [weak self] queryText in
            guard let self = self else { return }
            self.listCoordinator = ListCoordinator(presenter: self.presenter, searchedUser: queryText!)
            self.listCoordinator?.start()
        }
        presenter.pushViewController(favoritesViewController, animated: true)
    }
}
