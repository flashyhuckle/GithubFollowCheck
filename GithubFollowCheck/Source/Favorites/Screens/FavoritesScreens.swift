//
//  FavoritesScreens.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

struct FavoritesScreens {
    func createFavoritesViewController(didTapTableViewCell: ((String?) -> Void)?) -> FavoritesViewController {
        FavoritesViewController(didTapTableViewCell: didTapTableViewCell)
    }
}
