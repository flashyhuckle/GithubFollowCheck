import UIKit

final class DetailCoordinator: CoordinatorType {
    //MARK: Properties
    
    private let screens: DetailScreens = DetailScreens()
    private let presenter: UINavigationController
    private let user: User
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, user: User) {
        self.presenter = presenter
        self.user = user
    }
    
    func start() {
        let detailViewController = screens.createDetailViewController(user: user)
        presenter.pushViewController(detailViewController, animated: true)
    }
}
