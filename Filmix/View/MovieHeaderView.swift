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
        image.sd_setImage(with: URL(string: "https://cdn1.ozone.ru/s3/multimedia-n/6509170235.jpg"))
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

}
