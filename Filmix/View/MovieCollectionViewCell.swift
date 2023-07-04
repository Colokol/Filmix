//
//  MovieCollectionViewCell.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 28.06.23.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"

    private let movieImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(movieImage)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        movieImage.frame = contentView.bounds
    }

    func configure(model:Movie){
        guard let imageUrl = model.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else {return}
        movieImage.sd_setImage(with: url)
    }

}
