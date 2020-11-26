//
//  PageViewCell.swift
//  COVID-19 Status
//
//  Created by Vinicius de Andrade Silva on 21/11/20.
//

import UIKit

struct PageInfo {
  var title: String
  var image: UIImage?
}

class PageViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var subtitleLabel: UILabel!
  @IBOutlet weak var subtitleHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func setupCell(with info: PageInfo) {
    imageView.image = info.image
    subtitleLabel.text = info.title.localized
    subtitleLabel.sizeToFit()
    
    let isHeightSmallEnough = subtitleLabel.frame.height < 62
    let subtitleHeight = isHeightSmallEnough ? subtitleLabel.frame.height : 62
    subtitleHeightConstraint.constant = subtitleHeight
  }
  
}
