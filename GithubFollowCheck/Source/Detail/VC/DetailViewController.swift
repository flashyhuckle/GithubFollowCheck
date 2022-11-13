//
//  DetailViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var user: Result? {
        didSet {
            if let url = URL(string: user!.avatar_url) {
                downloadImage(from: url)
            }
        }
    }
    
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
        label.text = user?.login
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(user: Result) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpConstraints()
    }
    
    private func setUpLayout() {
        view.backgroundColor = .blue
        view.addSubview(imageView)
        view.addSubview(label)
        
        if let url = URL(string: user!.avatar_url) {
            downloadImage(from: url)
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
    
    private func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
