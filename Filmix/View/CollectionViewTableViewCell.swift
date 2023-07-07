    //
    //  CollectionViewTableView.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

protocol CollectionViewTableViewDelegate: AnyObject {
    func collectonViewDidTap(cell: CollectionViewTableViewCell ,model:MovieModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    var movies:[Movie] = [Movie]()

    var delegate: CollectionViewTableViewDelegate?

    static let identefier = "CollectionViewTableViewCell"

    private let movieColectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 130, height: 208)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        let colection = UICollectionView(frame: .zero, collectionViewLayout: layout )
        colection.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        colection.showsHorizontalScrollIndicator = false
        return colection
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        movieColectionView.dataSource = self
        movieColectionView.delegate = self
        movieColectionView.backgroundColor = .systemBackground

        contentView.addSubview(movieColectionView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        movieColectionView.frame = contentView.bounds
    }

    public func configure(movies:[Movie]){
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.movieColectionView.reloadData()
        }
    }

    func saveDownloadMovie(indexPath: IndexPath){
        CoreDataManager.shared.saveData(model: movies[indexPath.row]) { result in
            switch result{
                case .success(()):
                    NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(model: movies[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(actionProvider:  { action in
            let action = UIAction(title: "Download") { action in
                self.saveDownloadMovie(indexPath: indexPaths[0])
            }
            return UIMenu(children: [action])
        })
        return config
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = movies[indexPath.row].original_title
        let overview =  movies[indexPath.row].overview
        APICaller.shared.searchMovieYoutube(searchMovie: movies[indexPath.row].original_title ?? "trailer") { [weak self] result in
            guard let self = self else {return}
            switch result {
                case .success(let video):
                    let movieModel = MovieModel(original_title: title, overview: overview, id: video)
                    self.delegate?.collectonViewDidTap(cell: self, model: movieModel)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}


