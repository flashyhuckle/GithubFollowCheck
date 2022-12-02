import UIKit

struct ListScreens {
    func createListViewController(searchedUser: String, didTapTableViewCell: ((UserDTO?) -> Void)?) -> ListViewController {
        let apiManager: ApiManagerInterface = NEWApiManager()
        let viewModel: ListViewModel = ListViewModel(
            searchedUser: searchedUser,
            apiManager: apiManager,
            didTapTableViewCell: didTapTableViewCell
        )
        return ListViewController(
            viewModel: viewModel
        )
    }
}
