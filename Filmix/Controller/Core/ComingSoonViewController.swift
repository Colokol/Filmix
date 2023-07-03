//
//  ComingSoonViewController.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 28.06.23.
//

import UIKit

class ComingSoonViewController: UIViewController {

    var movies = [Movie]()

    private let movieTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Coming soon"
        navigationController?.navigationBar.prefersLargeTitles = true

        movieTableView.dataSource = self
        movieTableView.delegate = self

        view.addSubview(movieTableView)

        fetchMovie()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieTableView.frame = view.bounds
    }

    func fetchMovie() {
        APICaller.shared.getComingSoonMovie { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let movie):
                    self.movies = movie
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                case.failure(let error):
                    print(error.localizedDescription)
            }
        }
    }


}


extension ComingSoonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.configure(model: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = movies[indexPath.row].original_title
        let overview =  movies[indexPath.row].overview

        APICaller.shared.searchMovieYoutube(searchMovie: movies[indexPath.row].original_title ?? "trailer") { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let video):
                    DispatchQueue.main.async {
                        let model = MovieModel(original_title: title, overview: overview, id: video)
                        let vc = MovieViewController()
                        vc.configure(model: model)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}
