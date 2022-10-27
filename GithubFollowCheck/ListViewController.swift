//
//  ViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class ListViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var favoriteUsers = [String]()
    
    var results = [Result]() {
        didSet {
            filteredArray = results
        }
    }
    var filteredArray = [Result]()
    var page = 1
    
    var searchedUser: String?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let searchBar = UISearchBar()
    
    var favoritesBarButtonON = UIBarButtonItem()
    var favoritesBarButtonOFF = UIBarButtonItem()
    var searchAllButton = UIBarButtonItem()
    
    var apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
            favoriteUsers = fav
        }
        
        view.backgroundColor = .white
        title = searchedUser
        
        favoritesBarButtonON = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoritesPressed))
        favoritesBarButtonOFF = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(favoritesPressed))
        searchAllButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(searchAll))
        
        if favoriteUsers.contains(searchedUser!) {
            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonOFF]
        } else {
            navigationItem.rightBarButtonItems = [searchAllButton, favoritesBarButtonON]
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        apiManager.delegate = self
        
        tableView.backgroundColor = .red
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.isTranslucent = false
        searchBar.sizeToFit()
        searchBar.delegate = self
        tableView.addSubview(searchBar)
        
        if searchedUser != nil {
            apiManager.fetchData(username: searchedUser!)
        }
    }
    
    @objc func favoritesPressed() {
        if favoriteUsers.contains(searchedUser!) {
            favoriteUsers = favoriteUsers.filter { $0 != searchedUser!}
            defaults.set(favoriteUsers, forKey: "favoriteUsers")
            navigationItem.setRightBarButtonItems([searchAllButton, favoritesBarButtonON], animated: false)
        } else {
            favoriteUsers.append(searchedUser!)
            navigationItem.setRightBarButtonItems([searchAllButton, favoritesBarButtonOFF], animated: false)
            defaults.set(favoriteUsers, forKey: "favoriteUsers")
        }
    }
    
    @objc func searchAll() {
        page += 1
        if searchedUser != nil {
            apiManager.fetchData(username: searchedUser!, page: page, getAll: true)
        }
    }
}

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
        let vc = DetailViewController()
        vc.user = results[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = results.count - 1
        if indexPath.row == lastItem {
            page += 1
            if searchedUser != nil {
                apiManager.fetchData(username: searchedUser!, page: page)
            }
        }
    }
}

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
            apiManager.fetchData(username: searchedUser!, page: page, getAll: true)
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
        if searchText.count == 0 {
            filteredArray = results
        }
        self.tableView.reloadData()
    }
    
}
