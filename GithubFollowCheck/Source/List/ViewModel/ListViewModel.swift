import Foundation

final class ListViewModel {
 
    // MARK: - Input

    private let userDefaults: UserDefaults = .standard

    let searchedUser: String
    private let apiManager: ApiManagerInterface
    private let didTapTableViewCell: ((UserDTO?) -> Void)?

    // MARK: - Output

    var didReceiveUsers: (([UserDTO]) -> Void)?

    // MARK: - Initialization

    init(
        searchedUser: String,
        apiManager: ApiManagerInterface,
        didTapTableViewCell: ((UserDTO?) -> Void)?
    ) {
        self.searchedUser = searchedUser
        self.apiManager = apiManager
        self.didTapTableViewCell = didTapTableViewCell
    }

    func getFavoriteUsers(
        forKey: String
    ) -> [String] {
        guard let favoriteUsers = userDefaults.array(forKey: forKey) as? [String] else { return [] }
        return favoriteUsers
    }

//    func viewDidLoad() {
//        getUser()
//    }

    func getUser(
        page: Int = 1
    )  {
//        guard let searchedUser = searchedUser else { return }
        apiManager.fetchData(
            username: searchedUser,
            page: page
        ) { [weak self] result in
            switch result {
            case .success(let users):
                self?.didReceiveUsers?(users)
            case .failure(let error):
                print("ERROR: \(error)")
            }
        }
    }

    func onTapTableViewCell(user: UserDTO?) {
        didTapTableViewCell?(user)
    }
}
