    //
    //  ApiYoutubeModel.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 2.07.23.
    //

import Foundation

struct ApiYoutubeModel: Codable {

    let items: [YoutubeResponse]
}

struct YoutubeResponse: Codable {
    let id : IdModel
}

struct IdModel: Codable {
    let videoId: String
    }
