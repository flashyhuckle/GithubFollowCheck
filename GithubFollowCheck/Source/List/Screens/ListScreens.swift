import UIKit

struct ListScreens {
    func createListViewController(searchedUser: String, didTapTableViewCell: ((User) -> Void)?) -> ListViewController {
        let apiManager: ApiManagerInterface = ApiManager()
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
