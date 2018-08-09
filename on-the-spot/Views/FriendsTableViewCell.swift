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
    @IBOutlet weak var checkBox: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        if selectButton != nil {
            selectButton.setTitle("Select", for: .normal)
            selectButton.setTitle("Selected", for: .selected)
        }
    }
    
    
}
