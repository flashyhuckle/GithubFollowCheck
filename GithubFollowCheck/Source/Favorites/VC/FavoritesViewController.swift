//
//  FavoritesViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 25/10/2022.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private var didTapTableViewCell: ((String?) -> Void)?
    private let defaults = UserDefaults.standard
    
    private var favoriteUsers = [String]()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    init(didTapTableViewCell: ((String?) -> Void)?) {
        super.init(nibName: nil, bundle: nil)
        self.didTapTableViewCell = didTapTableViewCell
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
    }
    
    private func setUpViews() {
        title = "Favorites"
        view.backgroundColor = .green
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
            favoriteUsers = fav
            tableView.reloadData()
        }
    }
}

//MARK: TableView functions

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = favoriteUsers[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Connect coordinator
        didTapTableViewCell?(favoriteUsers[indexPath.row])
    }
}
