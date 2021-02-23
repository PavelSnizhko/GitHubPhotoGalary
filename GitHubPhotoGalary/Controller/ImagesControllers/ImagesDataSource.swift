//
//  ImagesDataSource.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//

import UIKit
import CoreData

class ImagesDataSource: UITableViewFetchedResultsController<ImageEntity> {
    private var cellClass: UITableViewCell.Type
    private let context: NSManagedObjectContext
    
    init(at context: NSManagedObjectContext, for tableView: UITableView, displaying cellClass: UITableViewCell.Type) {
        self.context = context
        self.cellClass = cellClass
        let frc = ImagesFRC.make(at: context)
        
        super.init(with: tableView, and: frc)
        
        do {
            try frc.performFetch()
        } catch {
            print("frc.performFetch() faild")
        }
    }
    
    public func object(at indexPath: IndexPath) -> ImageEntity {
        frc.object(at: indexPath)
    }
}

extension ImagesDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return frc.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = frc.sections?[section] else {
            return 0
        }
        
        print("Стільки буде рядків \(sectionInfo.numberOfObjects)")
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageModel = object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellId, for: indexPath) as? TableViewCell
        cell?.imageModel = imageModel
        return cell ?? .init()
    }
}
