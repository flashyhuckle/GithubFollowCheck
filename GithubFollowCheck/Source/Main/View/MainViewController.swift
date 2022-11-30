//
//  MainViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class MainViewController: UIViewController {
    
//    private var didTapSearchButton: ((String?) -> Void)?
//    private var didTapFavoritesButton: (() -> Void)?
    
    private let viewModel: MainViewViewModel
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 5
        textField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        textField.textColor = .red
        textField.textAlignment = .center
        textField.placeholder = "Search User"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button: UIButton = UIButton()
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.role = .normal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoritesButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 5
        button.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        button.setTitle("Favorites", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.role = .normal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favoritesButtonPressed), for: .touchUpInside)
        return button
    }()
    
//    init(didTapSearchButton: ((String?) -> Void)?, didTapFavoritesButton: (() -> Void)?) {
//        super.init(nibName: nil, bundle: nil)
//        self.didTapSearchButton = didTapSearchButton
//        self.didTapFavoritesButton = didTapFavoritesButton
//    }
    
    init(
        viewModel: MainViewViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = nil
    }
    
    private func setUpViews() {
        view.backgroundColor = .yellow
        view.addSubview(searchButton)
        view.addSubview(textField)
        view.addSubview(favoritesButton)
    }
    
    private func setUpConstraints() {
        let height = 50.0
        let width = 200.0
        let spacing = 50.0
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: height),
            textField.widthAnchor.constraint(equalToConstant: width),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing * 3),
            
            searchButton.heightAnchor.constraint(equalToConstant: height),
            searchButton.widthAnchor.constraint(equalToConstant: width),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: spacing),
            
            favoritesButton.heightAnchor.constraint(equalToConstant: height),
            favoritesButton.widthAnchor.constraint(equalToConstant: width),
            favoritesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoritesButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: spacing)
        ])
    }
    
    @objc private func searchButtonPressed() {
//        if textField.text == "" { return }
//        didTapSearchButton?(textField.text)
        viewModel.onTapSearch(text: textField.text)
        
    }
    
    @objc private func favoritesButtonPressed() {
//        didTapFavoritesButton?()
        viewModel.onTapFavorites()
    }
}
