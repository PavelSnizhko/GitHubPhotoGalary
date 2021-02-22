//
//  ViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import UIKit

class ImagesViewController: UIViewController {
    var imagesTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagesTableView)
        imagesTableView.register(UINib(nibName: TableViewCell.cellId, bundle: .main), forCellReuseIdentifier: TableViewCell.cellId)
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        // TODO: make elegant logout
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    func setImagesTableViewConstraints() {
//        imagesTableView.translatesAutoresizingMaskIntoConstraints = false
//        imagesTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
//        imagesTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
//        imagesTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
//        imagesTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        
        imagesTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        imagesTableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        imagesTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        imagesTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    @objc func logoutUser(){
         print("clicked")
    }
}
