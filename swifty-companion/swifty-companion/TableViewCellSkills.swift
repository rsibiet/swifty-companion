//
//  TableViewCellSkills.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 19/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import UIKit

class TableViewCellSkills: UITableViewCell {

    @IBOutlet weak var skillsLabel: UILabel!
    @IBOutlet weak var result: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
