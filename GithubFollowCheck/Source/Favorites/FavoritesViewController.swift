//
//  FavoritesViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 25/10/2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var didTapTableViewCell: ((String?) -> Void)?
    let defaults = UserDefaults.standard
    
    private var favoriteUsers = [String]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = .white
        tableView.backgroundColor = .green
        
        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
            favoriteUsers = fav
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if let fav = defaults.array(forKey: "favoriteUsers") as? [String] {
            favoriteUsers = fav
            tableView.reloadData()
        }
    }
}

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
