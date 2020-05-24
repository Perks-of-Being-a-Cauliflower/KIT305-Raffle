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
    @IBOutlet var ticketColour: UIImageView!
    
    var specificTicketID: Int32!
    var specificCustomerTicketID: Int32!
    
    var customer:Customer?
    
    weak var delegate: CustomCellUpdater?


   
    @IBAction func refundTicket(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Confirm:", message: "Refunding this purchase cannot be reversed!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            return
        }))
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { action in
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
            database.deleteCustomer(id: self.specificCustomerTicketID)
            let ticket = database.selectTicketBy(id: self.specificTicketID)
            print("updating database: \(ticket!.ID) | \(ticket!.soldTickets-1)")
            database.updateSoldTickets(ticketID: ticket!.ID, newNum: ticket!.soldTickets-1)
            self.delegate!.updateTableView()
        }))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

protocol CustomCellUpdater: class { // the name of the protocol you can put any
        func updateTableView()
}
   
