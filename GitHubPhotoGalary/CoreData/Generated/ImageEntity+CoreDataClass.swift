//
//  ImageEntity+CoreDataClass.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//
//

import Foundation
import CoreData

@objc(ImageEntity)
public class ImageEntity: NSManagedObject {
   static public func clearAllCoreData() {
        let entities = CoreDataStack.shared.container.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    static func clearDeepObjectEntity(_ entity: String) {
        let context = CoreDataStack.shared.container.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("CoreData is cleaned")
        } catch {
            print("There was an error")
        }
    }
}
