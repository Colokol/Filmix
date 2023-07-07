    //
    //  DownloadViewController.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

class DownloadViewController: UIViewController {

    var movies = [MovieData]()

    private let movieTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true

        movieTableView.dataSource = self
        movieTableView.delegate = self

        view.addSubview(movieTableView)

        fetchMovieCoreData()

        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded") , object: nil, queue: nil) { _ in
            self.fetchMovieCoreData()
        }
    }

    func fetchMovieCoreData(){
        CoreDataManager.shared.fetchData { [weak self] result in
            guard let self = self else {return}
            switch result{
                case .success(let movie):
                    self.movies = movie
                    DispatchQueue.main.async {
                        self.movieTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieTableView.frame = view.bounds
    }


}

extension DownloadViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        cell.configureMovieData(model: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? ""
        let overview =  movies[indexPath.row].overview

        APICaller.shared.searchMovieYoutube(searchMovie: title) { [weak self] result in
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
            case .delete :
                CoreDataManager.shared.deletMovieCoreData(model: movies[indexPath.row]) { [weak self] result in
                    switch result {
                        case .success(()):
                            Void.self
                        case .failure(let error):
                            print(error.localizedDescription)
                    }
                    self?.movies.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            default: break;
        }
        

    }


}
