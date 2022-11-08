//
//  FavoritesCoordinator.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

final class FavoritesCoordinator: CoordinatorType {
    
    //MARK: Properties
    
    private let screens: FavoritesScreens = FavoritesScreens()
    private let presenter: UINavigationController
    private let apiManager: ApiManager
    
    //MARK: Child coordinators
    
    private var listCoordinator: ListCoordinator?
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, apiManager: ApiManager) {
        self.presenter = presenter
        self.apiManager = apiManager
    }
    
    //MARK: Start
    
    func start() {
        let favoritesViewController = screens.createFavoritesViewController { [weak self] queryText in
            guard let self = self else { return }
            self.listCoordinator = ListCoordinator(presenter: self.presenter, searchedUser: queryText, apiManager: self.apiManager)
            self.listCoordinator?.start()
        }
        presenter.pushViewController(favoritesViewController, animated: true)
    }
}
