import UIKit

struct DetailScreens {
    func createDetailViewController(user: UserDTO) -> DetailViewController {
        let apiManager: ApiManagerInterface = NEWApiManager()
        let viewModel = DetailViewModel(
            user: user,
            apiManager: apiManager
        )
        return DetailViewController(viewModel: viewModel)
    }
}
