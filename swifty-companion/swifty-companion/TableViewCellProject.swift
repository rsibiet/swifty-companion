//
//  TableViewCellProject.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 19/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import UIKit

class TableViewCellProject: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var score: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
