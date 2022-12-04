import UIKit

class ListViewController: UIViewController {
    
//    let defaults = UserDefaults.standard
    
    //MARK: - Properties
    private var favoriteUsers = [String]() {
        didSet {
            if favoriteUsers.contains(viewModel.searchedUser) {
                favoritesBarButton.image = UIImage(systemName: "star.fill") ?? UIImage()
            } else {
                favoritesBarButton.image = UIImage(systemName: "star") ?? UIImage()
            }
        }
    }
    
    private var filteredArray = [User]()
    
    private var results = [User]() {
        didSet {
            filteredArray = results
            self.tableView.reloadData()
        }
    }
    
    private var didTapTableViewCell: ((User) -> Void)?
    
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
        table.translatesAutoresizingMaskIntoConstraints = false
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    private lazy var favoritesBarButton = UIBarButtonItem(
        image: UIImage(),
        style: .plain, target: self,
        action: #selector(favoritesPressed)
    )
    
    //MARK: - Initialization
    init(
        viewModel: ListViewModel
    ) {
        self.viewModel = viewModel
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
        
        setupNavigationItems()
        viewModel.viewDidLoad()
        
//        favoriteUsers = defaults.array(forKey: "favoriteUsers") as! [String]
        
        viewModel.didReceiveUsers = { [ weak self ] users in
            self?.results += users
        }
        
        viewModel.didReceiveFavoriteUsers = { [ weak self ] favoriteUsers in
            //CZEMU KURWA NIE DZIAŁA
            self?.favoriteUsers = favoriteUsers
        }
    }

    private func setUpViews() {
        title = viewModel.searchedUser
        view.backgroundColor = .red
        
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

    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = favoritesBarButton
    }
    
    @objc private func favoritesPressed() {
        if viewModel.searchedUser.isEmpty { return }
        if favoriteUsers.contains(viewModel.searchedUser) {
            favoriteUsers = favoriteUsers.filter { $0 != viewModel.searchedUser}
            viewModel.updateFavoriteUsers(favoriteUsers: favoriteUsers)
        } else {
            favoriteUsers.append(viewModel.searchedUser)
            viewModel.updateFavoriteUsers(favoriteUsers: favoriteUsers)
        }
    }
}

//MARK: TableView functions

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = filteredArray[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onTapTableViewCell(user: filteredArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = results.count
        if indexPath.row == lastItem - 1 {
            viewModel.getNextPageUsers()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y == 0 {
            searchBarHeightConstraint?.constant = 40
        }
        
        guard scrollView.contentOffset.y > 0 else { return }

        if currentContentOffsetY > scrollView.contentOffset.y {
            guard searchBarHeightConstraint?.constant != 40 else { return }
            let growingHeight = currentContentOffsetY - scrollView.contentOffset.y
            let currentHeight = searchBarHeightConstraint?.constant ?? 0.0
            if growingHeight < 40.0 && growingHeight > currentHeight {
                searchBarHeightConstraint?.constant = growingHeight
            } else if growingHeight > 40 {
                searchBarHeightConstraint?.constant = 40
            }

        } else if currentContentOffsetY < scrollView.contentOffset.y {
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
        currentContentOffsetY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentContentOffsetY = scrollView.contentOffset.y
    }
}

//MARK: Searchbar Delegate

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = results.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        if searchText.isEmpty {
            filteredArray = results
        }
        tableView.reloadData()
    }
}
