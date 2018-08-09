//
//  ContactTableViewCell.swift
//  on-the-spot
//
//  Created by William Han on 7/26/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation

import UIKit

protocol ContactTableViewCellDelegate: class {
    func didTapFriendButton(_ FriendButton: UIButton, on cell: ContactTableViewCell)
    
}

class ContactTableViewCell: UITableViewCell {
    weak var delegate: ContactTableViewCellDelegate?
    
    
    @IBOutlet var ContactName: UILabel!
    
    @IBOutlet var FriendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        FriendButton.layer.borderColor = UIColor.lightGray.cgColor
        FriendButton.layer.borderWidth = 1
        FriendButton.layer.cornerRadius = 6
        FriendButton.clipsToBounds = true
        
        FriendButton.setTitle("Add Friend", for: .normal)
        FriendButton.setTitle("Friends", for: .selected)
        
    }
    
    
    
    @IBAction func friendButtonTapped(sender: UIButton) {
        delegate?.didTapFriendButton(sender, on: self)
    }
}
