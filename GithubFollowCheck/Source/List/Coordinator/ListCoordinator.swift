//
//  ListCoordinator.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

final class ListCoordinator: CoordinatorType {
    
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
