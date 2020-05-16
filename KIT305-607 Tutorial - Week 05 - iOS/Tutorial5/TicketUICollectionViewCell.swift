//
//  TIcketUICollectionViewCell.swift
//  Tutorial5
//
//  Created by Liam kenna on 2/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class TicketUICollectionViewCell: UICollectionViewCell {
        
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var ticketCounter: UILabel!

    @IBOutlet var iDLetter: UILabel!
    
    @IBOutlet var topColour: UIImageView!
    @IBOutlet var bottomColour: UIImageView!
    
    //@IBOutlet var button: TicketUIButton!
    var ticketID: Int32?
    
}
