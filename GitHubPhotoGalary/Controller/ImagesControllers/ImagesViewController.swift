//
//  ViewController.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 19.02.2021.
//

import UIKit
import WebKit
import CoreData
import KeychainAccess

class ImagesViewController: UIViewController {
    private var imageLoader: DataLoaderManager
    private let imagesTableView = UITableView()
    private var dataSource: ImagesDataSource?
    private let context: NSManagedObjectContext = CoreDataStack.shared.container.viewContext
    
    init(imageLoader: DataLoaderManager) {
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
        let keychain = Keychain(service: ProjectConstants.service)
        guard let token = keychain["access-token"] else { return }
        imageLoader.getImages(token: token)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imagesTableView)
        configureNavBar()
        self.prepareTableView()
        self.prepareDataSource()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imagesTableView.frame = view.bounds
    }
}

// MARK: - private extension

private extension ImagesViewController {
    func configureNavBar() {
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationItem.setHidesBackButton(true, animated: true)
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutUser))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
    }
    
    func prepareTableView() {
        let nib = UINib(nibName: TableViewCell.cellId, bundle: .main)
        imagesTableView.register(nib, forCellReuseIdentifier: TableViewCell.cellId)
        imagesTableView.delegate = self

    }
    
    func prepareDataSource() {
        dataSource = ImagesDataSource(at: context, for: imagesTableView, displaying: TableViewCell.self)
        imagesTableView.dataSource = dataSource
        imagesTableView.reloadData()
    }
}

// MARK: - log out

extension ImagesViewController: Logouting {
    
    @objc func logoutUser() {
         print("clicked")
        logOut()
        throwToRootController()
    }
}

// MARK: - UITableViewDelegate mwthods

extension UIViewController: UITableViewDelegate {
   
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TableViewCell, let imageData = cell.imageModel?.image, let image = UIImage(data: imageData, scale: 1.0) else { return }
        self.imageTapped(image: image)
    }

    func imageTapped(image: UIImage) {
        let newImageView = configureNewImageView(image: image)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configureNewImageView(image: UIImage) -> UIImageView {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        return newImageView
    }

    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

private extension ImagesViewController {
    func throwToRootController() {
        self.navigationController!.popToRootViewController(animated: true)
    }
}
