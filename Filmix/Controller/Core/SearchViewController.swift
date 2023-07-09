    //
    //  SearchViewController.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

class SearchViewController: UIViewController {


    var movies = [Movie]()

    private let searchControler: UISearchController =  {
        let search = UISearchController(searchResultsController: SearchResultViewController())
        search.searchBar.placeholder = "Search Movie"
        search.searchBar.tintColor = .black
        return search
    }()

    private let movieTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true

        movieTableView.dataSource = self
        movieTableView.delegate = self

        view.addSubview(movieTableView)

        navigationItem.searchController = searchControler
        searchControler.searchResultsUpdater = self

        fetchMovies()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        movieTableView.frame = view.bounds
    }

    func fetchMovies(){
        APICaller.shared.getTopRated { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let movie):
                    DispatchQueue.main.async {
                        self.movies = movie
                        self.movieTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }


}

//MARK: TableVeiew extension

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        cell.configure(model: movies[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        210
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = movies[indexPath.row].original_title ?? movies[indexPath.row].original_name ?? ""
        let overview = movies[indexPath.row].overview ?? ""
        APICaller.shared.searchMovieYoutube(searchMovie: title) { result in
            switch result {
                case .success(let video):
                    let movieModel = MovieModel(original_title: title, overview: overview, id: video)
                    DispatchQueue.main.async { [weak self] in
                        let vc = MovieViewController()
                        vc.configure(model: movieModel)
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}

//MARK:  Search extension

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControlerDelegate {
    func searchResultDidTap(model:MovieModel) {
        DispatchQueue.main.async {
            let vc = MovieViewController()
            vc.configure(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              query.count > 3,
              let resultSearch = searchController.searchResultsController as? SearchResultViewController else { return}
        resultSearch.delegate = self

        APICaller.shared.searchMovie(searchMovie: query) { result in
            switch result {
                case .success(let movie):
                    DispatchQueue.main.async {
                        resultSearch.movies = movie
                        resultSearch.searchCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}

//MARK:  Extension MovieTableCell

extension SearchViewController:MovieTableViewCellDelegate {
    func downloadButtonTapped(in cell: MovieTableViewCell) {
        guard let indexPath = movieTableView.indexPath(for: cell) else {return}
        CoreDataManager.shared.saveData(model: movies[indexPath.row]) { result in
            switch result {
                case .success(()):
                    NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    func showAlertAddMovie() {
        let allert = UIAlertController(title: "Movie added successfully", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        allert.addAction(action)

        present(allert, animated: true)
    }


}
