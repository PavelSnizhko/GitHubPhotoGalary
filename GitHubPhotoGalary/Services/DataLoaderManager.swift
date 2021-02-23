//
//  DataLoaderManager .swift
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
        guard let url = URL(string: APIConstants.url.rawValue) else { return }
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
        print("::::full Github Models::::")
        print(models)
        let newModels = findDiffFromRepo(filteredModels: models)
        print("::::will be added newModels :::::: \(newModels)" )
        newModels.forEach { model in
            imageNetworkingService?.loadImages(withURL: model.downloadURL) { result in
                switch result {
                case .success(let data):
                    ImageFactory.makeImage(from: data, name: model.name, sha: model.sha, completion: nil)
                case .failure(let error):
                    print("ERROR \(error)")
                }
            }
        }
    }
    
    func findDiffFromRepo(filteredModels: [GithubModel] ) -> [GithubModel] {
        var shaForDeleting: [String] = []
        var shaSet = Set(filteredModels.map { $0.sha })
        let fetchRequest: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        do {
            // use viewContect for reading always
            let images = try self.container.viewContext.fetch(fetchRequest)
            print(images)
            images.forEach {
                guard let sha = $0.sha else { return }
                if !shaSet.contains(sha) {
                    shaForDeleting.append(sha)
                    shaSet.remove(sha)
                } else {
                    shaSet.remove(sha)
                }
            }
            self.deleteFromCoreData(imageEntitiesSHA: shaForDeleting)
            let modelsForAppending = filteredModels.filter { shaSet.contains( $0.sha ) }
            return modelsForAppending
        } catch {
            fatalError("This was not supposed to happen")
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
    
    func deleteFromCoreData(imageEntitiesSHA: [String]) {
        print("Probablly its gonna DIED \(imageEntitiesSHA)")
//
//        let deletedGroup = DispatchGroup()
//        deletedGroup.enter()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ImageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "sha IN %@", imageEntitiesSHA)
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            print("will be deleted \(batchDeleteRequest)")
               _ = try context.execute(batchDeleteRequest)
               try context.save()
            print("Data is deleted")
                
                let managedObjContext = CoreDataStack.shared.container.viewContext
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImageEntity")
                do {
//                    deletedGroup.leave()
//                    let images = try managedObjContext.fetch(fetchRequest)
//                    images.forEach{ print(($0 as? ImageEntity)?.name)}
                } catch let error as NSError {
                    print("Error while fetching the data:: ",error.description)
                }
            
           } catch {
               print("Something wrong. Probably images are not exist at all")
           }
       }
}
