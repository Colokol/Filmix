//
//  CoreDataManager.swift
//  Filmix
//
//  Created by Uladzislau Yatskevich on 4.07.23.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let shared = CoreDataManager()

    enum ErrorCore: Error {
        case ErrorSaveDownloadItem
        case ErrorFetchItem
        case ErrorDeletItem
    }

    func saveData(model: Movie, completion: @escaping (Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext
        let itemMovie = MovieData(context: context)

        itemMovie.id = Int64(model.id)
        itemMovie.original_name = model.original_name
        itemMovie.original_title = model.original_title
        itemMovie.overview = model.overview
        itemMovie.poster_path = model.poster_path
        do{
            try context.save()
            completion(.success(()))
        }catch {
            completion(.failure(ErrorCore.ErrorSaveDownloadItem))
        }
    }

    func fetchData(completion: @escaping (Result<[MovieData],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext

        let request = MovieData.fetchRequest()

        do{
           let movieDataResult = try context.fetch(request)
            completion(.success(movieDataResult))
        }catch {
            completion(.failure(ErrorCore.ErrorFetchItem))
        }
    }

    func deletMovieCoreData(model:MovieData, completion: @escaping (Result<Void,Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext

        context.delete(model)
        do {
            try  context.save()
            completion(.success(()))
        }catch {
            completion(.failure(ErrorCore.ErrorDeletItem))
        }
    }

    func deleteAllData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}

        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to delete data: \(error)")
        }
    }


}
