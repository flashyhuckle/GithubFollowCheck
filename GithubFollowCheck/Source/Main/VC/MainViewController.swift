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
    
    lazy var searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 100, width: 200, height: 50)
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.role = .normal
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2, width: 200, height: 50)
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.role = .normal
        button.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 200, width: 200, height: 50)
        textField.layer.borderWidth = 5
        textField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        textField.textColor = .red
        textField.textAlignment = .center
        textField.placeholder = "Search User"
        return textField
    }()
    
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
        setUpViews()
    }
    
    private func setUpViews() {
        view.backgroundColor = .yellow
        view.addSubview(searchButton)
        view.addSubview(textField)
        view.addSubview(favoritesButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = nil
    }
    
    @objc func searchButtonPressed() {
        if textField.text == "" { return }
        didTapSearchButton?(textField.text)
    }
    
    @objc func favoritesButtonPressed() {
        didTapFavoritesButton?()
    }
}
