import Foundation

final class ListViewModel {
    
    // MARK: - Input
    
    private let userDefaults: UserDefaults = .standard
    let searchedUser: String
    private let apiManager: ApiManagerInterface
    private let didTapTableViewCell: ((User) -> Void)?
    private var currentPage = 1
    
    // MARK: - Output
    
    var didReceiveUsers: (([User]) -> Void)?
    var didReceiveFavoriteUsers: (([String]) -> Void)?
    
    // MARK: - Initialization
    
    init(
        searchedUser: String,
        apiManager: ApiManagerInterface,
        didTapTableViewCell: ((User) -> Void)?
    ) {
        self.searchedUser = searchedUser
        self.apiManager = apiManager
        self.didTapTableViewCell = didTapTableViewCell
    }
    
    func viewDidLoad() {
        getFavoriteUsers()
        getUsers()
    }
    
    private func getFavoriteUsers() {
        guard let favoriteUsers = userDefaults.array(forKey: "favoriteUsers") as? [String] else { return }
        didReceiveFavoriteUsers?(favoriteUsers)
    }
    
    func updateFavoriteUsers(
        favoriteUsers: [String]
    ) {
        userDefaults.set(favoriteUsers, forKey: "favoriteUsers")
    }

    func getNextPageUsers() {
        currentPage += 1
        getUsers(for: currentPage)
    }

    private func getUsers(
        for page: Int = 1
    )  {
        apiManager.fetchData(
            username: searchedUser,
            page: page
        ) { [weak self] result in
            switch result {
            case .success(let users):
                guard let self else { return }
                self.didReceiveUsers?(users)

            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }

    func onTapTableViewCell(user: User) {
        didTapTableViewCell?(user)
    }
}
