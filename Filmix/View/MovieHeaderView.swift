    //
    //  MovieHeaderView.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 28.06.23.
    //

import UIKit

import SDWebImage

class MovieHeaderView: UIView {


    private let movieImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(movieImage)

    }

    required init?(coder: NSCoder) {
        fatalError()

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        movieImage.frame = bounds
    }

    func configure(model:Movie) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.poster_path ?? "")") else {return}
        movieImage.sd_setImage(with: url)
    }

}
