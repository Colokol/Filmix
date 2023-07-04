    //
    //  CollectionViewTableView.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

class CollectionViewTableViewCell: UITableViewCell {

    var movie:[Movie] = [Movie]()

    static let identefier = "CollectionViewTableViewCell"

    private let movieColectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 200, height: 250)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 30
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
        self.movie = movies
        DispatchQueue.main.async { [weak self] in
            self?.movieColectionView.reloadData()
        }
    }

    func saveDownloadMovie(indexPath: IndexPath){
        CoreDataManager.shared.saveData(model: movie[indexPath.row]) { result in
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
        return movie.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell()}
        cell.configure(model: movie[indexPath.row])
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





}
