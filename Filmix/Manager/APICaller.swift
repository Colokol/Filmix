    //
    //  APICaller.swift
    //  Filmix
    //
    //  Created by Uladzislau Yatskevich on 1.07.23.
    //

import Foundation

struct Constant {

    static let apiKey = "?api_key=2ccb88f4299526a108aa391f57d577c0"
    static let baseUrl = "https://api.themoviedb.org"
    static let youtubeApiKey = "AIzaSyB8HOpXamJz25ZYW1TyLwTlqRFVRhuERN8"
    static let baseYoutubeUrl = "https://youtube.googleapis.com/youtube/v3/search?q="

}

class APICaller {

    static let shared = APICaller()

    func fetchData(url:URL, completion: @escaping (Result<[Movie],Error>) -> Void ) {

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            do{
                let result = try JSONDecoder().decode(ApiMovieModel.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    public func getPopularMovie(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard  let url = URL(string: "\(Constant.baseUrl)/3/movie/popular\(Constant.apiKey)") else {return}
        fetchData(url: url, completion: completion)
    }


    public func getComingSoonMovie(completion: @escaping (Result<[Movie],Error>) -> Void) {
        guard let url = URL(string: "\(Constant.baseUrl)/3/movie/upcoming\(Constant.apiKey)") else {return}
        fetchData(url: url, completion: completion)
    }

    func getTopRated(completion:@escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseUrl)/3/movie/top_rated\(Constant.apiKey)") else {return}
        fetchData(url: url, completion: completion)
        }

    func getNowPlaingMovie(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseUrl)/3/movie/now_playing\(Constant.apiKey)") else {return}
        fetchData(url: url, completion: completion)
    }

    func getPopularTv(completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let url = URL(string: "\(Constant.baseUrl)/3/trending/tv/week\(Constant.apiKey)") else {return}
        fetchData(url: url, completion: completion)
    }

    func searchMovie(searchMovie: String, completion: @escaping (Result<[Movie],Error>) -> Void){
        guard let query = searchMovie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constant.baseUrl)/3/search/movie\(Constant.apiKey)&query=\(query)") else {return}
        fetchData(url: url, completion: completion)
    }

    func searchMovieYoutube(searchMovie:String, completion: @escaping (Result<IdModel,Error>) -> Void) {
        guard let query = searchMovie.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        guard let url = URL(string: "\(Constant.baseYoutubeUrl)\(query)&key=\(Constant.youtubeApiKey)") else {
            return}
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            do {
                let result = try JSONDecoder().decode(ApiYoutubeModel.self, from: data)
                completion(.success(result.items[0].id))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

}
