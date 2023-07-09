    //
    //  HomeViewController.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

enum SectionName: Int {
    case PopularFilm = 0
    case ComingSoon = 2

}

class HomeViewController: UIViewController {

    let category = ["Now Plaing","Popular","Trending TV", "Upcoming movies", "Top rated"]

    private var header:MovieHeaderView?

    private let homeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identefier)
        return tableView
    }()

    private let searchControler: UISearchController = {
        let search = UISearchController(searchResultsController: SearchResultViewController())
        search.searchBar.placeholder = "Search"
        search.searchBar.tintColor = .black
        return search
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        header = MovieHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height / 2))

        homeTableView.tableHeaderView = header
        homeTableView.dataSource = self
        homeTableView.delegate = self

        navigationItem.searchController = searchControler
        searchControler.searchResultsUpdater = self

        setNavigationBarItem()
        setRandomHeader()

        view.addSubview(homeTableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }

    func setNavigationBarItem() {

        var image = UIImage(named: "logo")
        image = image?.withRenderingMode(.alwaysOriginal)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchBar)),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .plain, target: nil, action: nil)
        ]

        navigationController?.navigationBar.tintColor = .black
    }

    func setRandomHeader(){
        APICaller.shared.getTopRated { result in
            switch result {
                case .success(let movie):
                    guard let randomMovie = movie.randomElement() else {return}
                    self.header?.configure(model: randomMovie)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    @objc func searchBar(){
        searchControler.isActive.toggle()
    }

}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identefier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self

        func fetchMovie(result:(Result<[Movie],Error>)){
            switch result {
                case .success(let movies):
                    cell.configure(movies: movies)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }

        switch indexPath.section {
            case 0: APICaller.shared.getNowPlaingMovie { result in
                fetchMovie(result: result)
            }
            case 1:
                APICaller.shared.getPopularMovie { result in
                    fetchMovie(result: result)
                }
            case 2 :
                APICaller.shared.getPopularTv { result in
                    fetchMovie(result: result)
                }
            case 3 :
                APICaller.shared.getComingSoonMovie { result in
                    fetchMovie(result: result)
                }
            case 4 : APICaller.shared.getTopRated { result in
                fetchMovie(result: result)
            }
            default: break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        25
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return   category[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return category.count
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
        header.textLabel?.textColor = .black
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let saveArea = view.safeAreaInsets.top
        let offset = saveArea + scrollView.contentOffset.y
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -offset)
    }
}


extension HomeViewController: CollectionViewTableViewDelegate {
    func collectonViewDidTap(cell: CollectionViewTableViewCell, model: MovieModel) {
        DispatchQueue.main.async {
            let vc = MovieViewController()
            vc.configure(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

extension HomeViewController: UISearchResultsUpdating, SearchResultViewControlerDelegate {
    func searchResultDidTap(model: MovieModel) {
        DispatchQueue.main.async {
            let vc = MovieViewController()
            vc.configure(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if text.count > 3, let resultControler = searchController.searchResultsController as? SearchResultViewController {
            resultControler.delegate = self
            APICaller.shared.searchMovie(searchMovie: text) { result in
                switch result {
                    case .success(let movie):
                        DispatchQueue.main.async {
                            resultControler.movies = movie
                            resultControler.searchCollectionView.reloadData()
                        }

                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }

}
