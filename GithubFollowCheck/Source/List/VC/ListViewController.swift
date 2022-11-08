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
        table.backgroundColor = .red
        table.frame = view.bounds
        return table
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.sizeToFit()
        return searchBar
    }()
    
    lazy var favoritesBarButtonON = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoritesPressed))
    lazy var favoritesBarButtonOFF = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favoritesPressed))
    lazy var searchAllButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchAll))
    
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
        handlingUser()
    }
    
    private func setUpViews() {
        view.backgroundColor = .white
        title = searchedUser
        
        apiManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        searchBar.delegate = self
        tableView.addSubview(searchBar)
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
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = filteredArray[indexPath.row].login
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didTapTableViewCell?(filteredArray[indexPath.row])
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

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = results.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        if searchText.isEmpty {
            filteredArray = results
        }
        self.tableView.reloadData()
    }
}
