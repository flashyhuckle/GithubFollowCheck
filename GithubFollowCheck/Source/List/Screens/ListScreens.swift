//
//  ListScreens.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

struct ListScreens {
    func createListViewController(searchedUser: String?, didTapTableViewCell: ((UserDTO?) -> Void)?) -> ListViewController {
        let NEWapiManager: ApiManagerInterface = NEWApiManager()
        let viewModel: ListViewModel = ListViewModel(
            searchedUser: searchedUser,
            apiManager: NEWapiManager,
            didTapTableViewCell: didTapTableViewCell
        )
        return ListViewController(
            viewModel: viewModel,
//            apiManager: apiManager,
            searchedUser: searchedUser
        )
    }
}
