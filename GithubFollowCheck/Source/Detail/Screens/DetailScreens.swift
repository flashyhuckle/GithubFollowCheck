import UIKit

struct DetailScreens {
    func createDetailViewController(user: User) -> DetailViewController {
        let apiManager: ApiManagerInterface = ApiManager()
        let viewModel = DetailViewModel(
            user: user,
            apiManager: apiManager
        )
        return DetailViewController(viewModel: viewModel)
    }
}
