//
//  UITableViewFetchedResultsController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 22.02.2021.
//

import UIKit
import CoreData

private protocol UITableViewFetchedResultsControllable: NSFetchedResultsControllerDelegate {
    
    associatedtype EntityType: NSFetchRequestResult
    
    var tableView: UITableView { get }
    
    var frc: NSFetchedResultsController<EntityType> { get }
}

class UITableViewFetchedResultsController<T: NSFetchRequestResult>: NSObject,
                                                                    UITableViewFetchedResultsControllable {

    typealias EntityType = T
    
    private(set) var tableView: UITableView
    private(set) var frc: NSFetchedResultsController<T>
    
    init(with tableView: UITableView, and frc: NSFetchedResultsController<T>) {
        self.tableView = tableView
        self.frc = frc
        super.init()
        self.frc.delegate = self
    }

    // MARK: - CRUD
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {

        let indexSet = IndexSet(integer: sectionIndex)

        switch type {
        case .insert:
            tableView.insertSections(indexSet, with: .none)
        case .delete:
            tableView.deleteSections(indexSet, with: .none)
        default: break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
      
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .none)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .none)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .none)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .none)
            tableView.insertRows(at: [newIndexPath!], with: .none)
        @unknown default:
            print("Unexpected NSFetchedResultsChangeType")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
