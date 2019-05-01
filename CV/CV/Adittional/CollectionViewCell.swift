//
//  CollectionViewCell.swift
//  CollectionView
//
//  Created by Roman Mishchenko on 4/10/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var isEditing: Bool = false {
        didSet{
            selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet{
            if isEditing{
                selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
}
