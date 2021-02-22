//
//  ImageLoaderManager .swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import Foundation
import CoreData

class DataLoaderManager {
    private let imageTypesSet: Set<String> = ProjectConstants.fileTypes
    private let imageNetworkingService: ImageNetworking?
    private let container: NSPersistentContainer
    
    init(imageNetworkingService: ImageNetworking?, container: NSPersistentContainer) {
        self.imageNetworkingService = imageNetworkingService
        self.container = container
    }

    func getImages(token: String) {
        print("MY TOKEN ", token)
        guard let url = URL(string: GithubConstants.url.rawValue) else { return }
        imageNetworkingService?.loadGithubModels(withURL: url, token: token, type: [GithubModel].self) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                let filteredModels = self.filterGithubModels(from: models)
                self.getImageBinaryData(using: filteredModels)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getImageBinaryData(using models: [GithubModel]) {
        models.forEach { model in
            imageNetworkingService?.loadImages(withURL: model.downloadURL) { result in
                switch result {
                case .success(let data):
                    //TODO before making should I ckeck if it's exist or not
                    ImageFactory.makeImage(from: data, name: model.name, sha: model.sha, completion: nil)
                case .failure(let error):
                    print("ERROR \(error)")
                }
            }
        }
    }
    
    func findDiffFromRepository(token: String) {
        guard let url = URL(string: GithubConstants.url.rawValue) else { return }
        imageNetworkingService?.loadGithubModels(withURL: url, token: token, type: [GithubModel].self) { [weak self]  result in
            guard let self = self else { return }
            var modelsForDeleting: [ImageEntity.ID] = []

            switch result {
            case .success(let models):

                var filteredModels = self.filterGithubModels(from: models)
                var shaSet = Set(filteredModels.map { $0.sha })
                let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
                
                do {
                    // use viewContect for reading always?
                    let images = try self.container.viewContext.fetch(fetchRequest)
                    print(type(of: images))
                    images.forEach { image in
                        guard let sha = image.sha else { return }
                        if !shaSet.contains(sha) {
                            modelsForDeleting.append(image.id)
                            shaSet.remove(sha)
                        } else {
                            shaSet.remove(sha)
                        }
                    }
                    self.deleteFromCoreData(imageEntitiesId: modelsForDeleting)
                    // filter and awoke func to load new photos
                    let modelsForAppending = filteredModels.filter{ shaSet.contains( $0.sha ) }
                    self.getImageBinaryData(using: modelsForAppending)

                } catch {
                    fatalError("This was not supposed to happen")
                }
            case .failure(let error):
                // TODO: alert that time of session is over
                print(error)
            }
        }

    }
    
    
        
    func filterGithubModels(from githubModels: [GithubModel]) -> [GithubModel] {
        var imageModels: [GithubModel] = [ ]
        githubModels.forEach { model in
            let fileName = model.name
            if let lastDotIndex = fileName.lastIndex(of: ".") {
                let fileType = String(fileName[lastDotIndex..<fileName.endIndex])
                if imageTypesSet.contains(fileType) {
                    imageModels.append(model)
                }
            }
        }
        return imageModels
    }
    
    
    func deleteFromCoreData(imageEntitiesId: [ImageEntity.ID]) {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ID in %@", imageEntitiesId)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
               _ = try context.execute(batchDeleteRequest)
               try context.save()
           } catch {
               print("Something wrong. Probably images are not exist at all")
           }
       }
}
