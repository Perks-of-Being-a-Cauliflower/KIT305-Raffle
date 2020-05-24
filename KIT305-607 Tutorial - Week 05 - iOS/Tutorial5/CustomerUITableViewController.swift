//
//  CustomerUITableViewController.swift
//  Tutorial5
//
//  Created by Liam kenna on 9/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
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
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        
        let ticket = database.selectTicketBy(id: iDFromPreviousView)
        
        customers = database.selectAllCustomersFromRaffle(id: ticket!.ID)
        print("LOAD WITH: " + ticket!.name + " | " + String(ticket!.ID))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateTableView()
        //super.viewDidLoad()
        /*let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        
        let ticket = database.selectTicketBy(id: iDFromPreviousView)
        
        customers = database.selectAllCustomersFromRaffle(id: ticket!.ID)
        print("LOAD WITH: " + ticket!.name + " | " + String(ticket!.ID))*/
    }
    
    func updateTableView() {
        print("yyyxxx")
        let database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        let ticket = database.selectTicketBy(id: iDFromPreviousView)
        customers = database.selectAllCustomersFromRaffle(id: ticket!.ID)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerUITableViewCell", for: indexPath) as! CustomerUITableViewCell
        
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        ticket = database.selectTicketBy(id: iDFromPreviousView)
        let ticketCost = ticket!.price
        
        
        
        
        orderList = customers.sorted(by: { $0.ticketNum > $1.ticketNum})
        //print("ordered list: ", orderList)
        customer = orderList[(orderList.count-1) - indexPath.row] //displays most recently added ticket at top.
        //print("ordered list 2: ", customer!.ticketNum)
        
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
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
