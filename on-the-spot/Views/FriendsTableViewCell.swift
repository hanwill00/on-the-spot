//
//  FriendsTableViewCell.swift
//  on-the-spot
//
//  Created by William Han on 7/27/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

protocol FriendsTableViewCellDelegate: class {
    
    func didTapSelectButton(_ selectButton: UIButton, on cell: FriendsTableViewCell)
    
}

class FriendsTableViewCell: UITableViewCell {
    weak var delegate: FriendsTableViewCellDelegate?
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
//    @IBAction func selectButtonTapped(_ sender: UIButton) {
//        delegate?.didTapSelectButton(sender, on: self)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectButton.layer.borderColor = UIColor.lightGray.cgColor
        selectButton.layer.borderWidth = 1
        selectButton.layer.cornerRadius = 6
        selectButton.clipsToBounds = true
    }
    
    
}
