//
//  TicketUITableViewController.swift
//  Tutorial5
//
//  Created by Liam kenna on 2/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class TicketUITableViewController: UITableViewController {

    var tickets = [Ticket]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        database.insert(ticket:Ticket(open:1, name:"Debug Joe's Big BBQ", desc:"Wow ! its time for a big BBQ with Debug Joe yeehaw YEEEHAW",margin:0,price:1.99,iDLetter:"B",colour:1))
            
        database.insert(ticket:Ticket(open:1, name:"Debug Moe's Bigger BBQ", desc:"COME TO THE BIGGEST BBQ YET (WAY COOLER THAN JOES BBQ)",margin:1,price:4.99,iDLetter:"A",colour:2))

        tickets = database.selectAllTickets()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
