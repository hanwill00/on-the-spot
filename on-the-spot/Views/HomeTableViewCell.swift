//
//  listNotesTableViewCell.swift
//  on-the-spot
//
//  Created by William Han on 7/24/18.
//  Copyright © 2018 Will Han. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    var didTapOptionsButtonForCell: ((HomeTableViewCell) -> Void)?

    @IBOutlet weak var adminName: UILabel!
    @IBOutlet weak var hangoutName: UILabel!
    
    @IBAction func optionsButtonTapped(_ sender: UIButton) {
        didTapOptionsButtonForCell?(self)
    }
    
}
