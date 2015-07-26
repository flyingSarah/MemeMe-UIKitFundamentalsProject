//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Sarah Howe on 7/24/15.
//  Copyright (c) 2015 SarahHowe. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memedImage: UIImageView!
    
    func setNewMemedImage(newImage: UIImage)
    {
        memedImage.image = newImage
    }
}
