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
        //name.text = "poo"
        print("poo")
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        
        database.deleteCustomer(id: specificCustomerTicketID)
        
        var customers = database.selectAllCustomersFromRaffle(id: specificTicketID)
        
        var ticket = database.selectTicketBy(id: specificTicketID)
        
        //var cap = (ticket?.soldTickets)!
        var curr = Int32(ticketNum.text!)
        
        for customer in customers{
            if(customer.ticketNum > curr!){
                database.updateCustomerTicketNumber(ticketID: customer.ID, ticketNumber: customer.ticketNum-1)
                print("bumped down by 1")
            }
        }
        /*for i in stride(from: curr!, to: (cap + 1), by: 1) {
            print(i+1)
            
            //find customer ID
            //database.findCustomer
            database.updateCustomerTicketNumber(ticketID: <#T##Int32#>, ticketNumber: 0)
            
        }*/
        
        print("updating database: \(ticket!.ID) | \(ticket!.soldTickets-1)")
        database.updateSoldTickets(ticketID: ticket!.ID, newNum: ticket!.soldTickets-1)
        delegate!.updateTableView()
        //customer.ticketID
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol CustomCellUpdater: class { // the name of the protocol you can put any

        
        func updateTableView()
   }
   
