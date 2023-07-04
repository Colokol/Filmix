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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.searchController = searchControler

        searchControler.searchResultsUpdater = self

    }


}


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
