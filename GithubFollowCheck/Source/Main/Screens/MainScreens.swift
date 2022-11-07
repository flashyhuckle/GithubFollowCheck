//
//  MainScreens.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 02/11/2022.
//

import UIKit

struct MainScreens {
    func createMainViewController(didTapSearchButton: ((String?) -> Void)?, didTapFavoritesButton: (() -> Void)?) -> UIViewController {
        MainViewController(didTapSearchButton: didTapSearchButton, didTapFavoritesButton: didTapFavoritesButton)
    }
}

struct ListScreens {
    func createListViewController(apiManager: ApiManager, searchedUser: String?, didTapTableViewCell: ((Result?) -> Void)?) -> ListViewController {
        ListViewController(apiManager: apiManager, searchedUser: searchedUser, didTapTableViewCell: didTapTableViewCell)
    }
}

struct FavoritesScreens {
    func createFavoritesViewController(didTapTableViewCell: ((String?) -> Void)?) -> FavoritesViewController {
        FavoritesViewController(didTapTableViewCell: didTapTableViewCell)
    }
}

struct DetailScreens {
    func createDetailViewController(user: Result) -> DetailViewController {
        DetailViewController(user: user)
    }
}
