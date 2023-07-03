//
//  SearchResultViewController.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 2.07.23.
//

import UIKit

protocol SearchResultViewControlerDelegate {
    func searchResultDidTap(model:MovieModel)
}

class SearchResultViewController: UIViewController {

    var movies = [Movie]()

    var delegate: SearchResultViewControlerDelegate?

    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: UIScreen.main.bounds.height / 3 - 50)
        layout.scrollDirection = .vertical
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self

        view.addSubview(searchCollectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        searchCollectionView.frame = view.bounds
    }

}


extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(model: movies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let title = self.movies[indexPath.row].original_title
        let overview =  self.movies[indexPath.row].overview

        APICaller.shared.searchMovieYoutube(searchMovie: movies[indexPath.row].original_title ?? "") { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let video):
                    let model = MovieModel(original_title: title, overview: overview, id: video)
                    delegate?.searchResultDidTap(model: model)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}
