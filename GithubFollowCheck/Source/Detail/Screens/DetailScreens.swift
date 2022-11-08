//
//  DetailScreens.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 08/11/2022.
//

import UIKit

struct DetailScreens {
    func createDetailViewController(user: Result) -> DetailViewController {
        DetailViewController(user: user)
    }
}
