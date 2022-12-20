import UIKit

final class ListViewController: UIViewController {
    
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
    
    private var filteredArray = [User]() {
        didSet {
            mainCollectionView.reloadData()
        }
    }
    
    private var results = [User]() {
        didSet {
            filteredArray = results
            mainCollectionView.reloadData()
        }
    }
    
    //MARK: - ViewModel
    private let viewModel: ListViewModel
    
    //MARK: - Views
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.itemSize = .init(width: 100.0, height: 100.0)
        return layout
    }()

    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var favoritesBarButton = UIBarButtonItem(
        image: UIImage(systemName: "star"),
        style: .plain, target: self,
        action: #selector(favoritesPressed)
    )
    
    let searchController = UISearchController()
    
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
        
        viewModel.didReceiveUsers = { [ weak self ] users in
            self?.results += users
        }
        
        viewModel.didReceiveFavoriteUsers = { [ weak self ] users in
            self?.favoriteUsers = users
        }
        
        viewModel.viewDidLoad()
    }
    
    private func setUpViews() {
        title = viewModel.searchedUser
        view.backgroundColor = .red
        
        view.addSubview(mainCollectionView)
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ListCollectionViewCell",
            for: indexPath
        ) as? ListCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.update(user: filteredArray[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = mainCollectionView.frame.width
        let widthPerItem  = availableWidth * 0.3
        
        return CGSizeMake(widthPerItem, widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        viewModel.onTapCollectionViewCell(user: filteredArray[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = results.count
        if indexPath.item == lastItem - 1 {
            viewModel.getNextPageUsers()
        }
    }
}

extension ListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredArray = results.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        if searchText.isEmpty {
            filteredArray = results
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredArray = results
    }
}
