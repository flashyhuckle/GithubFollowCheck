//
//  DetailCoordinator.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

final class DetailCoordinator: CoordinatorType {
    //MARK: Properties
    
    private let screens: DetailScreens = DetailScreens()
    private let presenter: UINavigationController
    private let user: UserDTO
    
    //MARK: Initialization
    
    init(presenter: UINavigationController, user: UserDTO) {
        self.presenter = presenter
        self.user = user
    }
    
    func start() {
        let detailViewController = screens.createDetailViewController(user: user)
        presenter.pushViewController(detailViewController, animated: true)
    }
}
