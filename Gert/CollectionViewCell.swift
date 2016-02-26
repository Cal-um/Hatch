//
//  CollectionViewCell.swift
//  Gert
//
//  Created by Calum Harris on 17/02/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  
  @IBOutlet weak var PhotoImageView: UIImageView!
 
  
  
  func changeToAspectFill() {
    self.PhotoImageView.contentMode = .ScaleAspectFill
  }

  func changeToAspectFit() {
    self.PhotoImageView.contentMode = .ScaleAspectFit
  }


}