//
//  TableViewCell.swift
//  GitHubPhotoGalary
//
//  Created by Павел Снижко on 21.02.2021.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let cellId = "TableViewCell"
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var customImageView: UIImageView!
    
    weak var imageModel: ImageEntity? {
        didSet {
            nameLabel.text = imageModel?.name
            guard let imageData = imageModel?.image  else {
                customImageView.image = nil
                return
            }
            customImageView.image = UIImage(data: imageData, scale: 1.0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customImageView.contentMode = .scaleAspectFit
        self.customImageView.clipsToBounds = true
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageModel = nil
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
