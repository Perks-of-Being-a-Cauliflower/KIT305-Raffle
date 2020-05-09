//
//  SecondViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController {

    
    
    var ticket: Ticket?
    

    @IBOutlet weak var ticketGoal: UITextField!
    @IBOutlet weak var colourBarTwo: UIImageView!
    @IBOutlet weak var colourBarOne: UIImageView!
    @IBOutlet var ticketName: UILabel!
    @IBOutlet var totalCost: UILabel!
    var nameFromPreviousView: String?
    var colourFromPreviousView: UIColor? = UIColor.red
    var databaseFromPreviousView: SQLiteDatabase?
    //var cTicket = Ticket?()
    
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerPhone: UITextField!
    @IBOutlet var customerEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(ticket?.name)
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        //let ticket = databaseFromPreviousView!.selectTicketName(name: nameFromPreviousView!)
        let ticket = database.selectTicketName(name: nameFromPreviousView!)
        //print("database data is: ", database.selectTicketName(name: nameFromPreviousView!))
        if(ticket == nil){
            //throw error, there is no data here.
            print("ticket nil")
        }else{
            //let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
            print("ticket not nil")
            
            //var ticket = database.selectTicketBy(id:ticketID!)
            ticketName.text = ticket?.name
            ticketName.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            let totePrice:String = String(format:"$ %.1f", ticket!.price)
            //let goal:String = String(format:"%.1f", ticket!.)
            totalCost.text = totePrice
            //ticketGoal.text = goal
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            //print("colour is: ", colors[ticket!.colour] as Any)
            //print("sees colour as: ", ticket?.colour as Any)
            colourBarOne.backgroundColor = colors[ticket!.colour]
            colourBarTwo.backgroundColor = colors[(ticket?.colour)!]
            
            //ticketName.text = self.name
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func AddCustomer(_ sender: Any) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        
        if(ticket == nil){
            print("found lost name")
            ticket = database.selectTicketName(name: nameFromPreviousView!)
        }
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd-MM-yyyy "
        let now = df.string(from: Date())
        
        //currently just works with selling one ticket, need to make it look for the lowest unallocated value, as well as the ability to sell multiple tickets.
        print(ticket!.name)
        ticket!.soldTickets = ticket!.soldTickets + 1
        let num = ticket!.soldTickets
        database.updateSoldTickets(ticketID: ticket!.ID, newNum: num)
        //impliment a way to increase and track ticket numbers. via ticket SQL
            //also need to impliment a way to sell multiple tickets via a stepper. 
        database.insertCustomer(customer:Customer(ticketID: ticket?.ID ?? -1,
                                                  ticketNum: num,
                                                  purchaseTime: now,
                                                  refunded: 0,
                                                  name: customerName.text!,
                                                  phone: Int32(customerPhone.text ?? "") ?? -1,
                                                  email: customerEmail.text ?? ""))
        
        print("added Customer")
        customerName.text = ""
        customerPhone.text = ""
        customerEmail.text = ""
        print(database.selectAllCustomers())
    }
    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "TransferToTicketEdit"
           {
               //createTicketTable()
                print("zong!")
               
                let nextScreen = segue.destination as! SettingsViewController

                nextScreen.nameFromPreviousView = nameFromPreviousView
                /*
               nextScreen.databaseFromPreviousView = database
               if let ticketCost = Double(ticketPrice.text!) {
                   database.insertTicket(ticket:Ticket(open:1, name: chosenNameField.text!, desc:desField.text!,margin:Int32(switchState(for: marginSwitch!)),price:ticketCost,iDLetter:idfield.text!,colour:colourField.text!))
               } else {
                   print("\nnot submitting: \(ticketPrice.text!)")
                   ticketPrice.text = ""
               }
        */
               
               //let nextScreen = segue.destination as! SecondViewController
               //nextScreen.nameFromPreviousView = confirmedName.text
               //nextScreen.colourFromPreviousView = colourBar1.backgroundColor ?? UIColor.white
               
           }
           
       }

}
