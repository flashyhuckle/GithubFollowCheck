//
//  ViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    private var favoriteUsers = [String]()
    
    private var results = [Result]() {
        didSet {
            filteredArray = results
        }
    }
    
    private var filteredArray = [Result]()
    private var page = 1
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(ListViewSearchBarCell.self, forCellReuseIdentifier: "SearchBarCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var favoritesBarButtonON = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoritesPressed))
    private lazy var favoritesBarButtonOFF = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favoritesPressed))
    private lazy var searchAllButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchAll))
    
    private var apiManager = ApiManager()
    private let searchedUser: String?
    private var didTapTableViewCell: ((Result?) -> Void)?
    
    init(apiManager: ApiManager, searchedUser: String?, didTapTableViewCell: ((Result?) -> Void)?) {
        self.apiManager = apiManager
        self.searchedUser = searchedUser
        self.didTapTableViewCell = didTapTableViewCell
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        handlingUser()
    }
    
    private func setUpViews() {
        title = searchedUser
        view.backgroundColor = .red
        
        apiManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func handlingUser() {
        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
            favoriteUsers = fav
        }
        guard let searchedUser = searchedUser else { return }
        apiManager.fetchData(username: searchedUser)
        
        if favoriteUsers.contains(searchedUser) {
            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonOFF]
        } else {
            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonON]
        }
    }
    
    @objc private func favoritesPressed() {
        guard let searchedUser = searchedUser else { return }
        if searchedUser.isEmpty { return }
        if favoriteUsers.contains(searchedUser) {
            favoriteUsers = favoriteUsers.filter { $0 != searchedUser}
            defaults.set(favoriteUsers, forKey: "favoriteUsers")
            navigationItem.setRightBarButtonItems([searchAllButton, favoritesBarButtonON], animated: false)
        } else {
            favoriteUsers.append(searchedUser)
            navigationItem.setRightBarButtonItems([searchAllButton, favoritesBarButtonOFF], animated: false)
            defaults.set(favoriteUsers, forKey: "favoriteUsers")
        }
    }
    
    @objc private func searchAll() {
        page += 1
        guard let searchedUser = searchedUser else { return }
        apiManager.fetchData(username: searchedUser, page: page, getAll: true)
    }
}

//MARK: TableView functions

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBarCell") as? ListViewSearchBarCell {
                cell.searchBar.delegate = self
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
                cell.textLabel?.text = filteredArray[indexPath.row-1].login
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapTableViewCell?(filteredArray[indexPath.row - 1])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = results.count - 1
        if indexPath.row == lastItem {
            page += 1
            guard let searchedUser = searchedUser else { return }
            apiManager.fetchData(username: searchedUser, page: page)
        }
    }
}

//MARK: API Delegate

extension ListViewController: ApiManagerDelegate {
    
    func didReceiveResult(result: [Result]) {
        results += result
        print("you have \(results.count) results")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didReceiveResultOfMany(result: [Result]) {
        if result.isEmpty {
            print("you have \(results.count) results")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            results += result
            page += 1
            guard let searchedUser = searchedUser else { return }
            apiManager.fetchData(username: searchedUser, page: page, getAll: true)
            print("\(results.count) results and counting...")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: Searchbar Delegate

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = results.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        if searchText.isEmpty {
            filteredArray = results
        }
        self.tableView.reloadData()
    }
}
