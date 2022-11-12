//
//  ListViewSearchBarCell.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 11/11/2022.
//

import UIKit

class ListViewSearchBarCell: UITableViewCell {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let delegate = UISearchBarDelegate?.self
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "SearchBarCell")
        self.setUpLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func setUpLayout() {
        contentView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            searchBar.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            searchBar.topAnchor.constraint(equalTo: contentView.topAnchor)
        ])
    }
}
