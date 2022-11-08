//
//  ListScreens.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

struct ListScreens {
    func createListViewController(apiManager: ApiManager, searchedUser: String?, didTapTableViewCell: ((Result?) -> Void)?) -> ListViewController {
        ListViewController(apiManager: apiManager, searchedUser: searchedUser, didTapTableViewCell: didTapTableViewCell)
    }
}
