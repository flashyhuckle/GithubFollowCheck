//
//  MainCoordinator.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 02/11/2022.
//

import UIKit

protocol CoordinatorType {
    func start()
}

final class MainCoordinator: CoordinatorType {
    //MARK: properties
    
    private var navigationViewController: UINavigationController = UINavigationController()
    private var screens: MainScreens = MainScreens()
    private let presenter: UIWindow
    private let apiManager: ApiManager
    
    //MARK: Child coordinators
    
    private var searchCoordinagor: SearchCoordinator?
    private var favoritesCoordinator: FavoritesCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UIWindow, apiManager: ApiManager) {
        self.presenter = presenter
        self.apiManager = apiManager
    }
    
    //MARK: Start
    
    func start() {
        let mainViewController = screens.createMainViewController { [weak self] queryText in
            guard let self = self else { return }
            self.searchCoordinagor = SearchCoordinator(presenter: self.navigationViewController, searchedUser: queryText, apiManager: self.apiManager)
            self.searchCoordinagor?.start()
        } didTapFavoritesButton: {
            self.favoritesCoordinator = FavoritesCoordinator(presenter: self.navigationViewController, apiManager: self.apiManager)
            self.favoritesCoordinator?.start()
        }
        
        navigationViewController.viewControllers = [mainViewController]
        presenter.rootViewController = navigationViewController
    }
}

final class SearchCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: ListScreens = ListScreens()
    private let presenter: UINavigationController
    private let searchedUser: String?
    private let apiManager: ApiManager
    
    //MARK: Child coordinators
    
    private var detailCoordinagor: DetailCoordinator?
    
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, searchedUser: String?, apiManager: ApiManager) {
        self.presenter = presenter
        self.searchedUser = searchedUser
        self.apiManager = apiManager
    }
    
    //MARK: Start
    
    func start() {
        let listViewController = screens.createListViewController(apiManager: apiManager, searchedUser: searchedUser) { [weak self] result in
            guard let self = self else { return }
            self.detailCoordinagor = DetailCoordinator(presenter: self.presenter, user: result!)
            self.detailCoordinagor?.start()
        }
        presenter.pushViewController(listViewController, animated: true)
    }
}

final class FavoritesCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: FavoritesScreens = FavoritesScreens()
    private let presenter: UINavigationController
    private let apiManager: ApiManager
    
    //MARK: Child coordinators
    
    private var searchCoordinagor: SearchCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, apiManager: ApiManager) {
        self.presenter = presenter
        self.apiManager = apiManager
    }
    
    //MARK: Start
    
    func start() {
        let favoritesViewController = screens.createFavoritesViewController { [weak self] queryText in
            guard let self = self else { return }
            self.searchCoordinagor = SearchCoordinator(presenter: self.presenter, searchedUser: queryText, apiManager: self.apiManager)
            self.searchCoordinagor?.start()
        }
        presenter.pushViewController(favoritesViewController, animated: true)
    }
}

final class DetailCoordinator: CoordinatorType {
    //MARK: Properties
    
    private let screens: DetailScreens = DetailScreens()
    private let presenter: UINavigationController
    private let user: Result
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, user: Result) {
        self.presenter = presenter
        self.user = user
    }
    
    func start() {
        let detailViewController = screens.createDetailViewController(user: user)
        presenter.pushViewController(detailViewController, animated: true)
    }
}
