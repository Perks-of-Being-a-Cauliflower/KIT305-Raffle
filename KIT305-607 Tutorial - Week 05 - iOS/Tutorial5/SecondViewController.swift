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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
