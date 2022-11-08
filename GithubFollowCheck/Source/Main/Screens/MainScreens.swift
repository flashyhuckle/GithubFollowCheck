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
