//
//  StreetLevelTableViewCell.swift
//  ukpd
//
//  Created by Alex Chesters on 30/08/2018.
//  Copyright © 2018 Alex Chesters. All rights reserved.
//

import UIKit

class StreetLevelTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var outcomeLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var outcomeTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
