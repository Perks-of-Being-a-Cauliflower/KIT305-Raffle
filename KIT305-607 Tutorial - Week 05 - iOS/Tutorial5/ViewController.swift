//
//  ViewController.swift
//  Tutorial5
//
//  Created by Lindsay Wells.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate
{

    // a handle to the database itself
    // you can switch databases or create new blank ones by changing databaseName
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")
    
    @IBOutlet weak var titleField: UILabel!
    
    @IBOutlet weak var confirmedName: UITextField!
    @IBOutlet weak var desField: UITextField!
    @IBOutlet weak var ticketPrice: UITextField!
    @IBOutlet weak var endCon: UITextField!
    
    
    @IBOutlet weak var descriptInput: UITextView!
    @IBOutlet weak var chosenNameField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    

    

    
    
    @IBAction func showInputMenu(_ sender: UITextField) {
        chosenNameField.isUserInteractionEnabled = false
        desField.isUserInteractionEnabled = false
        ticketPrice.isUserInteractionEnabled = false
        endCon.isUserInteractionEnabled = false
        chosenNameField.resignFirstResponder()
        desField.resignFirstResponder()
        ticketPrice.resignFirstResponder()
        endCon.resignFirstResponder()
        if let opt = Options(tag: sender.tag) {
            print (opt.options)
            titleField.text = opt.options
            if sender.tag == 1 {
                confirmedName.isUserInteractionEnabled = true
                confirmedName.isHidden = false
                confirmedName.becomeFirstResponder()
                let temp: String? = chosenNameField.text
                confirmedName.text = temp
            } else if sender.tag == 2 {
                descriptInput.isUserInteractionEnabled = true
                descriptInput.isHidden = false
                descriptInput.becomeFirstResponder()
                let temp: String? = desField.text
                descriptInput.text = temp
            } else if sender.tag == 3 {
                confirmedName.keyboardType = UIKeyboardType.numberPad
                confirmedName.isUserInteractionEnabled = true
                confirmedName.isHidden = false
                confirmedName.becomeFirstResponder()
                let temp: String? = ticketPrice.text
                confirmedName.text = temp
            } else if sender.tag == 4 {
                confirmedName.isUserInteractionEnabled = true
                confirmedName.isHidden = false
                confirmedName.becomeFirstResponder()
                let temp: String? = endCon.text
                confirmedName.text = temp
                
            }
            popUpView.isHidden = false
        }
        
       
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        let returnField: String? = titleField.text
        confirmedName.isUserInteractionEnabled = false
        descriptInput.isUserInteractionEnabled = false
        chosenNameField.isUserInteractionEnabled = true
        desField.isUserInteractionEnabled = true
        ticketPrice.isUserInteractionEnabled = true
        endCon.isUserInteractionEnabled = true
        if returnField == "Name:" {
            confirmedName.isHidden = true
            let newName: String? = confirmedName.text
            chosenNameField.text = newName
        } else if returnField == "Description:" {
            descriptInput.isHidden = true
            let newName: String? = descriptInput.text
            desField.text = newName
        } else if returnField == "Price:" {
            confirmedName.isHidden = true
            let newName: String? = confirmedName.text
            ticketPrice.text = newName
            confirmedName.keyboardType = UIKeyboardType.default
        } else if returnField == "Select End Condition:" {
            confirmedName.isHidden = true
            let newName: String? = confirmedName.text
            endCon.text = newName
        }
        popUpView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            confirmedName.keyboardType = UIKeyboardType.default
            chosenNameField.isUserInteractionEnabled = true
            desField.isUserInteractionEnabled = true
            ticketPrice.isUserInteractionEnabled = true
            endCon.isUserInteractionEnabled = true
            confirmedName.isUserInteractionEnabled = false
            descriptInput.isUserInteractionEnabled = false
            descriptInput.isHidden = true
            confirmedName.isHidden = true
            popUpView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.isHidden = true
        chosenNameField.allowsEditingTextAttributes = false
        desField.allowsEditingTextAttributes = false
        ticketPrice.allowsEditingTextAttributes = false
        endCon.allowsEditingTextAttributes = false
        //confirmedName.becomeFirstResponder()
        //chosenNameField.isUserInteractionEnabled = false
        
        //createTicketTable()
        
        database.insert(ticket:Ticket(open:1, name:"Debug Joe's Big BBQ", desc:"Wow ! its time for a big BBQ with Debug Joe yeehaw YEEEHAW",margin:0,price:1.99,iDLetter:"B",colour:1))
            
        database.insert(ticket:Ticket(open:1, name:"Debug Moe's Bigger BBQ", desc:"COME TO THE BIGGEST BBQ YET (WAY COOLER THAN JOES BBQ)",margin:1,price:4.99,iDLetter:"A",colour:2))

        print(database.selectAllTickets())
    }


}

