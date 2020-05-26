//
//  CustomerUITableViewController.swift
//  Tutorial5
//
//  Created by Liam Kenna on 9/5/20.
//  Copyright © 2020 Liam Kenna. All rights reserved.
//

import UIKit

class CustomerUITableViewController: UITableViewController, CustomCellUpdater {
    var customers = [Customer]()
    var orderList = [Customer]()
    var nameFromPreviousView: String?
    var iDFromPreviousView: Int32 = 0
    var ticket : Ticket?
    var customer : Customer?
    
    // MARK: - ViewDidLoad
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase2")
        
        let ticket = database.selectTicketBy(id: iDFromPreviousView)
        
        customers = database.selectAllCustomersFromRaffle(id: ticket!.ID)
        print("LOAD WITH: " + ticket!.name + " | " + String(ticket!.ID))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
    }
    
    func updateTableView() {
        print("yyyxxx")
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase2")
        let ticket = database.selectTicketBy(id: iDFromPreviousView)
        customers = database.selectAllCustomersFromRaffle(id: ticket!.ID)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerUITableViewCell", for: indexPath) as! CustomerUITableViewCell
        
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase2")
        ticket = database.selectTicketBy(id: iDFromPreviousView)
        let ticketCost = ticket!.price
        
        
        
        // sorting code reference https://stackoverflow.com/questions/26719744/swift-sort-array-of-objects-alphabetically
        orderList = customers.sorted(by: { $0.ticketNum > $1.ticketNum})
        customer = orderList[(orderList.count-1) - indexPath.row] //displays most recently added ticket at top.
        
        if let  customerCell = cell as? CustomerUITableViewCell
        {
            customerCell.name.text = customer?.name
            customerCell.ticketNum.text = String(customer!.ticketNum)
            customerCell.purchaseTime.text = String(customer!.purchaseTime)
            customerCell.ticketCost.text = "$" + String(ticketCost)
            customerCell.customer = customer
            
            customerCell.specificTicketID = customer?.ticketID
            customerCell.specificCustomerTicketID = customer?.ID
            
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            
            customerCell.ticketColour.backgroundColor = colors[ticket!.colour]
                cell.delegate = self
                
                return cell
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
            if segue.identifier == "EditTicket"
            {
                guard let detailViewController = segue.destination as? EditTicketController else
            {
                fatalError("Unexpected destination: \(segue.destination)") }
                guard let selectedCustomerCell = sender as? CustomerUITableViewCell else
            {
                fatalError("Unexpected sender: \( String(describing: sender))") }
                guard let indexPath = tableView.indexPath(for: selectedCustomerCell) else
            {
                fatalError("The selected cell is not being displayed by the table") }
                let selectedCustomer = orderList[(orderList.count-1) - indexPath.row]
                print("selected Cust: ", selectedCustomer)
                print("index path: ", (orderList.count-1) - indexPath.row)
                detailViewController.customer = selectedCustomer
                detailViewController.curRaffle = ticket
        }
    }
}
