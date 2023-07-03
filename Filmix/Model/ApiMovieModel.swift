    //
    //  ApiMovieModel.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 1.07.23.
    //

import Foundation

struct ApiMovieModel: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let original_title, original_name, overview: String?
    let poster_path, release_date, title: String?
}
