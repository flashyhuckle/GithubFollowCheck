import UIKit

final class ListCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: ListScreens = ListScreens()
    private let presenter: UINavigationController
    private let searchedUser: String
    
    //MARK: Child coordinators
    
    private var detailCoordinagor: DetailCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, searchedUser: String) {
        self.presenter = presenter
        self.searchedUser = searchedUser
    }
    
    //MARK: Start
    
    func start() {
        let listViewController = screens.createListViewController(searchedUser: searchedUser) { [weak self] user in
            guard let self = self else { return }
            self.detailCoordinagor = DetailCoordinator(presenter: self.presenter, user: user)
            self.detailCoordinagor?.start()
        }
        presenter.pushViewController(listViewController, animated: true)
    }
}
