//
 //  MovieTableViewCell.swift
 //  Filmix
 //
 //  Created by Uladzislau Yatskevich on 2.07.23.
 //

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"

    private let movieImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let movieLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(movieImageView)
        contentView.addSubview(movieLabel)

        setConstraints()

    }



    required init?(coder: NSCoder) {
        fatalError()

    }

    func setConstraints () {
        NSLayoutConstraint.activate([
            movieImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            movieImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 150),

            movieLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            movieLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 20),
            movieLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50)

        ])
    }

    func configure(model:Movie){
        guard let imageUrl = model.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else {return}
        movieImageView.sd_setImage(with: url)

        movieLabel.text = model.original_title ?? ""
    }

    func configureMovieData(model:MovieData){
        guard let imageUrl = model.poster_path else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imageUrl)") else {return}
        movieImageView.sd_setImage(with: url)

        movieLabel.text = model.original_title ?? model.original_name ?? ""
    }

}

