//
//  ViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    //MARK: - Properties
    private let defaults = UserDefaults.standard
    private var favoriteUsers = [String]()
    private var filteredArray = [UserDTO]()
    
    private var results = [UserDTO]() {
        didSet {
            filteredArray = results
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var page = 1
    
    //MARK: - ViewModel
    
    private let viewModel: ListViewModel
    
    //MARK: - Views
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var searchBarHeightConstraint: NSLayoutConstraint?
    private var currentContentOffsetY: Double = 0
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.register(ListViewSearchBarCell.self, forCellReuseIdentifier: "SearchBarCell")
        table.translatesAutoresizingMaskIntoConstraints = false
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    private lazy var favoritesBarButtonON = UIBarButtonItem(
        image: UIImage(systemName: "star"),
        style: .plain, target: self,
        action: #selector(favoritesPressed)
    
    )
    
    private lazy var favoritesBarButtonOFF = UIBarButtonItem(
        image: UIImage(systemName: "star.fill"),
        style: .plain, target: self,
        action: #selector(favoritesPressed)
    
    )
    
    private lazy var searchAllButton = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(searchAll)
    )
    
//    private var apiManager = ApiManager()
    private let searchedUser: String?
    private var didTapTableViewCell: ((UserDTO?) -> Void)?
    
    //MARK: - Initialization
    
//    init(apiManager: ApiManager, searchedUser: String?, didTapTableViewCell: ((ChujowyResult?) -> Void)?) {
//        self.apiManager = apiManager
//        self.searchedUser = searchedUser
//        self.didTapTableViewCell = didTapTableViewCell
//
//        super.init(nibName: nil, bundle: nil)
//    }
    
    init(
        viewModel: ListViewModel,
//        apiManager: ApiManager,
        searchedUser: String?
    ) {
        self.viewModel = viewModel
//        self.apiManager = apiManager
        self.searchedUser = searchedUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        
        updateFavoriteUsers()
        handlingUser()
        setupNavigationItems()
        
        viewModel.didReceiveUsers = { [ weak self ] users in
            self?.results += users
        }
    }

    
    private func setUpViews() {
        title = searchedUser
        view.backgroundColor = .red
        
//        apiManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        searchBar.delegate = self
        view.addSubview(searchBar)
        }
    
    private func setUpConstraints() {
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 40.0)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        searchBarHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func updateFavoriteUsers() {
        favoriteUsers = viewModel.getFavoriteUsers(forKey: "favoriteUsers")
//        guard let favoriteUsers = defaults.array(forKey: "favoriteUsers") as? [String] else { return }
//        self.favoriteUsers = favoriteUsers
    }

    private func handlingUser() {
//        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
//            favoriteUsers = fav
//        }
        guard let searchedUser = searchedUser else { return }
//        apiManager.fetchData(username: searchedUser)
        viewModel.getUser()
//
//        if favoriteUsers.contains(searchedUser) {
//            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonOFF]
//        } else {
//            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonON]
//        }
    }

    private func setupNavigationItems() {
        guard let searchedUser = searchedUser else { return }
        switch favoriteUsers.contains(searchedUser) {
        case true:
            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonOFF]
        case false:
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
//        page += 1
//        guard let searchedUser = searchedUser else { return }
//        apiManager.fetchData(username: searchedUser, page: page, getAll: true)
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
//        didTapTableViewCell?(filteredArray[indexPath.row])
        viewModel.onTapTableViewCell(user: filteredArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = results.count
        if indexPath.row == lastItem - 1 {
            page += 1
//            guard let searchedUser = searchedUser else { return }
//            apiManager.fetchData(username: searchedUser, page: page)
            viewModel.getUser(page: page)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 {
            searchBarHeightConstraint?.constant = 40
        }
        
        guard scrollView.contentOffset.y > 0 else { return }

//        print("current: \(currentContentOffsetY) || SV: \(scrollView.contentOffset.y)")

        if currentContentOffsetY > scrollView.contentOffset.y {
            // W GÓRĘ
            guard searchBarHeightConstraint?.constant != 40 else { return }
            let growingHeight = currentContentOffsetY - scrollView.contentOffset.y
            let currentHeight = searchBarHeightConstraint?.constant ?? 0.0
            if growingHeight < 40.0 && growingHeight > currentHeight {
                searchBarHeightConstraint?.constant = growingHeight
            } else if growingHeight > 40 {
                searchBarHeightConstraint?.constant = 40
            }

        } else if currentContentOffsetY < scrollView.contentOffset.y {
            // W DÓŁ
            guard searchBarHeightConstraint?.constant != 0 else { return }
            let shrinkingHeight = scrollView.contentOffset.y - currentContentOffsetY
            let currentHeight = searchBarHeightConstraint?.constant ?? 0.0
            if shrinkingHeight < currentHeight && shrinkingHeight > 0 {
                searchBarHeightConstraint?.constant = currentHeight - shrinkingHeight
            } else if shrinkingHeight > currentHeight {
                searchBarHeightConstraint?.constant = 0
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        currentDraggingContentOffsetY = scrollView.contentOffset.y
        currentContentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentContentOffsetY = scrollView.contentOffset.y
    }
}

//MARK: API Delegate

//extension ListViewController: ApiManagerDelegate {
//
//    func didReceiveResult(result: [ChujowyResult]) {
//        results += result
//        print("you have \(results.count) results")
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//
//    func didReceiveResultOfMany(result: [ChujowyResult]) {
//        if result.isEmpty {
//            print("you have \(results.count) results")
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        } else {
//            results += result
//            page += 1
//            guard let searchedUser = searchedUser else { return }
//            apiManager.fetchData(username: searchedUser, page: page, getAll: true)
//            print("\(results.count) results and counting...")
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//}

//MARK: Searchbar Delegate

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = results.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        if searchText.isEmpty {
            filteredArray = results
        }
        tableView.reloadData()
    }
}

