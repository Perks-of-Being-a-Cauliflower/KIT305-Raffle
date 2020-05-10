//
//  SettingsViewController.swift
//  Tutorial5
//
//  Created by Fiona Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var ticketTitle: UILabel!
    var nameFromPreviousView: String?
    var ticket: Ticket?
    
    @IBOutlet var ticketName: UITextField!
    @IBOutlet var ticketDescription: UITextField!
    @IBOutlet var endCondition: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticketTitle.text = nameFromPreviousView!
        // Do any additional setup after loading the view.
        ticketTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "TransferTicketArchive"
        {
            //createTicketTable()
            print("zing!")
            
            let nextScreen = segue.destination as! CustomerUITableViewController
            
            nextScreen.nameFromPreviousView = nameFromPreviousView
            
        }
        else if segue.identifier == "SaveAndExit"
        {
            print("zip!")
            let nextScreen = segue.destination as! SecondViewController
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
            
            ticket = database.selectTicketName(name: nameFromPreviousView!)
            
            if(ticketName.text != ""){
                ticket?.name = ticketName.text!
            }
            if(ticketDescription.text != ""){
                ticket?.desc = ticketDescription.text!
            }
            if(endCondition.text != ""){
                ticket?.maxTickets = Int32(endCondition.text!)!
            }
            //@IBOutlet var ticketName: UITextField!
            //@IBOutlet var ticketDescription: UITextField!
            //@IBOutlet var endCondition: UITextField!
            
            database.updateTicketInfo(ticket: ticket!)
            
            nextScreen.nameFromPreviousView = ticket?.name
            /*
            let updateStatementQuery = "UPDATE Ticket SET soldTickets = " + String(newNum) + " WHERE id = " + String(ticketID) + ";"
            
            updateWithQuery(updateStatementQuery,
            bindingFunction: { (updateStatement) in
                sqlite3_bind_int(updateStatement, 9, newNum)
            })*/
            
            //need to do the update shit
            
            //nextScreen.nameFromPreviousView = nameFromPreviousView
        }
        
        
    }
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
