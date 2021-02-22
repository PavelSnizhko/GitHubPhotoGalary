//
//  ImageEntity+CoreDataProperties.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//
//

import Foundation
import CoreData

extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var sha: String?

}

extension ImageEntity: Identifiable { }
