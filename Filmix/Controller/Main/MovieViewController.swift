//
//  MovieViewController.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 2.07.23.
//

import UIKit
import WebKit

class MovieViewController: UIViewController {

    private let videoMovie:WKWebView = {
        let video = WKWebView()
        video.translatesAutoresizingMaskIntoConstraints = false
        return video
    }()

    private let movieTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let movieOwerviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(videoMovie)
        view.addSubview(movieTitleLabel)
        view.addSubview(movieOwerviewLabel)

        setConstraints()
    }
    

    func setConstraints () {
        NSLayoutConstraint.activate([
            videoMovie.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            videoMovie.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoMovie.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoMovie.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.78),

            movieTitleLabel.topAnchor.constraint(equalTo: videoMovie.bottomAnchor, constant: 20),
            movieTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),

            movieOwerviewLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 20),
            movieOwerviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            movieOwerviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)

        ])
    }

    func configure(model:MovieModel){
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.id.videoId)") else {return}
        movieTitleLabel.text = model.original_title ?? ""
        movieOwerviewLabel.text = model.overview ?? ""
        videoMovie.load(URLRequest(url: url))
    }
}
