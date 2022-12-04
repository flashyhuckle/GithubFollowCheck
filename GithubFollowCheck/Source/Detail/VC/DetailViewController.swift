import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - ViewModel
    private var viewModel: DetailViewModel
    
    //MARK: - Views
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = viewModel.user.name
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialization
    init(
        viewModel: DetailViewModel
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
        setUpLayout()
        setUpConstraints()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .blue
        view.addSubview(imageView)
        view.addSubview(label)
        
        viewModel.getUserAvatar()
        
        viewModel.didReceiveAvatar = { [ weak self ] avatar in
            DispatchQueue.main.async() {
                self?.imageView.image = avatar
            }
        }
    }
    
    private func setUpConstraints() {
        let width = 200.0
        let height = 50.0
        let spacing = 100.0
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: width),
            imageView.widthAnchor.constraint(equalToConstant: width),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spacing),
            
            label.heightAnchor.constraint(equalToConstant: height),
            label.widthAnchor.constraint(equalToConstant: width),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: spacing)
        ])
    }
}
