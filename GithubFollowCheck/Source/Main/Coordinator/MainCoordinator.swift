import UIKit

protocol CoordinatorType {
    func start()
}

final class MainCoordinator: CoordinatorType {
    //MARK: properties
    
    private var navigationViewController: UINavigationController = UINavigationController()
    private var screens: MainScreens = MainScreens()
    private let presenter: UIWindow
    
    //MARK: Child coordinators
    
    private var listCoordinator: ListCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UIWindow) {
        self.presenter = presenter
    }
    
    //MARK: Start
    
    func start() {
        let mainViewController = screens.createMainViewController { [weak self] queryText in
            guard let self = self else { return }
            self.listCoordinator = ListCoordinator(presenter: self.navigationViewController, searchedUser: queryText)
            self.listCoordinator?.start()
        } didTapFavoritesButton: {
            self.favoritesCoordinator = FavoritesCoordinator(presenter: self.navigationViewController)
            self.favoritesCoordinator?.start()
        }
        
        navigationViewController.viewControllers = [mainViewController]
        presenter.rootViewController = navigationViewController
    }
}
