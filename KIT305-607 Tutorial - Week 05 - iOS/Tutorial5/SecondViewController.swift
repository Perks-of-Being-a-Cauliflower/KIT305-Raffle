//
//  SecondViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    
    var ticket: Ticket?
    
    @IBOutlet var ticketName: UILabel!
    @IBOutlet var totalCost: UILabel!
    
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerPhone: UITextField!
    @IBOutlet var customerEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(ticket == nil){
            //throw error, there is no data here.
            print("ticket nil")
        }else{
            //let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
            print("ticket not nil")
            
            //var ticket = database.selectTicketBy(id:ticketID!)
            ticketName.text = ticket?.name
            ticketName.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            
            
            //ticketName.text = self.name
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func AddCustomer(_ sender: Any) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd-MM-yyyy "
        let now = df.string(from: Date())
        
        
        //impliment a way to increase and track ticket numbers. via ticket SQL
            //also need to impliment a way to sell multiple tickets via a stepper. 
        database.insertCustomer(customer:Customer(ticketID: ticket?.ID ?? -1,
                                                  ticketNum: 1,
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
