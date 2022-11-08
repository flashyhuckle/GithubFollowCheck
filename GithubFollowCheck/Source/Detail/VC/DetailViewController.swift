//
//  DetailViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var user: Result?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2, width: 200, height: 100)
        label.text = user?.login
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 250, width: 200, height: 200)
        return imageView
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
    }
    
    private func setUpLayout() {
        view.backgroundColor = .blue
        view.addSubview(label)
        view.addSubview(imageView)
        
        if let url = URL(string: user!.avatar_url) {
            downloadImage(from: url)
        }
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
