//
//  CustomerUITableViewCell.swift
//  Tutorial5
//
//  Created by Liam kenna on 9/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class CustomerUITableViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var ticketNum: UILabel!
    @IBOutlet var ticketCost: UILabel!
    @IBOutlet var purchaseTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
