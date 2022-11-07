//
//  MainViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    var didTapSearchButton: ((String?) -> Void)?
    var didTapFavoritesButton: (() -> Void)?
    
    let searchButton: UIButton = {
        let button: UIButton = UIButton()
        return button
    }()
    
    let favoritesButton = UIButton()
    let textField = UITextField()
    
    init(didTapSearchButton: ((String?) -> Void)?, didTapFavoritesButton: (() -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.didTapSearchButton = didTapSearchButton
        self.didTapFavoritesButton = didTapFavoritesButton
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        
        searchButton.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 100, width: 200, height: 50)
        searchButton.layer.borderWidth = 5
        searchButton.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.red, for: .normal)
        searchButton.role = .normal
        searchButton.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        view.addSubview(searchButton)
        
        textField.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 200, width: 200, height: 50)
        textField.layer.borderWidth = 5
        textField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        textField.textColor = .red
        textField.textAlignment = .center
        textField.placeholder = "Search User"
        view.addSubview(textField)
        
        favoritesButton.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2, width: 200, height: 50)
        favoritesButton.layer.borderWidth = 5
        favoritesButton.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        favoritesButton.setTitle("Favorites", for: .normal)
        favoritesButton.setTitleColor(.red, for: .normal)
        favoritesButton.role = .normal
        favoritesButton.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
        view.addSubview(favoritesButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = nil
    }
    
    @objc func searchButtonPressed() {
        didTapSearchButton?(textField.text)
    }
    
    @objc func favoritesButtonPressed() {
        didTapFavoritesButton?()
    }
}
