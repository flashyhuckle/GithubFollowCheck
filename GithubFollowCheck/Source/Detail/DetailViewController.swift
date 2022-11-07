//
//  DetailViewController.swift
//  GithubFollowCheck
//
//  Created by Marcin Głodzik on 20/10/2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var user: Result?
    
    let label = UILabel()
    
    let imageView = UIImageView()
    
    init(user: Result) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        label.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2, width: 200, height: 100)
        label.textColor = .white
        label.text = user?.login
        label.textAlignment = .center
        view.backgroundColor = .blue
        
        view.addSubview(imageView)
        imageView.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 250, width: 200, height: 200)
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
        
        if let url = URL(string: user!.avatar_url) {
            downloadImage(from: url)
        }
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
