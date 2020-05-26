//
//  EditTicketController.swift
//  Tutorial5
//
//  Created by Will Colbert on 24/5/20.
//  Copyright © 2020 Will Colbert. All rights reserved.
//

import UIKit

class EditTicketController: UIViewController {

    var customers = [Customer]()
    var customer : Customer?
    var curRaffle : Ticket?
    @IBOutlet weak var editNameField: UITextField!
    @IBOutlet weak var editPhoneField: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var ticketNumDis: UILabel!
    @IBOutlet weak var barColour: UIImageView!
    @IBOutlet weak var ticketIDL: UILabel!
    @IBOutlet weak var ticketNumDis2: UILabel!
    
    @IBOutlet weak var editCustView: UIView!
    @IBOutlet weak var editCustTitle: UILabel!
    @IBOutlet weak var editCustBack: UIButton!
    @IBOutlet weak var editCustConfirm: UIButton!
    @IBOutlet weak var editCustField: UITextField!
    
    
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase2")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let displayCustomer = customer
        {
            editNameField.text = displayCustomer.name
            editPhoneField.text = String(displayCustomer.phone)
            editEmail.text = displayCustomer.email
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            barColour.backgroundColor = colors[curRaffle!.colour]
            ticketIDL.text = curRaffle?.iDLetter
            
            let num = displayCustomer.ticketNum
            
            if num == 0 {
                ticketIDL.text = "000"
                ticketNumDis2.text = "000"
            } else if num <= 9 {
                ticketNumDis.text = "00" + String(num)
                ticketNumDis2.text = "00" + String(num)
            } else if num >= 10 && num <= 99 {
                ticketNumDis.text = "0" + String(num)
                ticketNumDis2.text = "0" + String(num)
                } else {
                ticketNumDis.text = String(num)
                ticketNumDis2.text = String(num)
            }
            
            
            
            
        }
        
        
        
        
    }
    
    @IBAction func showInputMenu(_ sender: UITextField) {
        editEmail.isUserInteractionEnabled = false
        editPhoneField.isUserInteractionEnabled = false
        editNameField.isUserInteractionEnabled = false
        editEmail.resignFirstResponder()
        editPhoneField.resignFirstResponder()
        editNameField.resignFirstResponder()
        //print(sender.tag)
            if sender.tag == 1 {
                editCustTitle.text = "Edit Name: "
                editCustField.isUserInteractionEnabled = true
                editCustField.isHidden = false
                editCustField.becomeFirstResponder()
                let temp: String? = editNameField.text
                editCustField.text = temp
            } else if sender.tag == 2 {
                editCustTitle.text = "Edit Phone: "
                editCustField.keyboardType = UIKeyboardType.numberPad
                editCustField.isUserInteractionEnabled = true
                editCustField.isHidden = false
                editCustField.becomeFirstResponder()
                let temp: String? = editPhoneField.text
                editCustField.text = temp
            } else if sender.tag == 3 {
                editCustTitle.text = "Edit Email: "
                editCustField.isUserInteractionEnabled = true
                editCustField.isHidden = false
                editCustField.becomeFirstResponder()
                let temp: String? = editEmail.text
                editCustField.text = temp
            }
            editCustView.isHidden = false
        }
    
    @IBAction func confirmDetailsButton(_ sender: Any) {
        let returnField: String? = editCustTitle.text
        editCustField.isUserInteractionEnabled = false
        editEmail.isUserInteractionEnabled = true
        editPhoneField.isUserInteractionEnabled = true
        editNameField.isUserInteractionEnabled = true
        if returnField == "Edit Name: " {
            editCustField.isHidden = true
            let newName: String? = editCustField.text
            editNameField.text = newName
            print("ticketnum is: ", customer!.ticketNum)
            database.updateCustomerName(custID: customer!.ticketNum, newString: newName!)
        } else if returnField == "Edit Phone: " {
            editCustField.isHidden = true
            let newName: String? = editCustField.text
            editPhoneField.text = newName
            if let phoneN = Int(newName!) {
                let updateValue = Int32(phoneN)
                print("The user entered a value price of \(phoneN)")
                database.updateCustomerPhone(custID: customer!.ticketNum, newNum: updateValue)
            } else {
                print("Not a valid number: \(newName!)")
                editPhoneField.text = ""
            }
            //print(customerPhone.text!)
            editCustField.keyboardType = UIKeyboardType.default
        } else if returnField == "Edit Email: " {
            editCustField.isHidden = true
            let newName: String? = editCustField.text
            editEmail.text = newName
            database.updateCustomerEmail(custID: customer!.ticketNum, newString: newName!)
        }
        editCustView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            editCustField.keyboardType = UIKeyboardType.default
            editEmail.isUserInteractionEnabled = true
            editPhoneField.isUserInteractionEnabled = true
            editNameField.isUserInteractionEnabled = true
            editCustField.isUserInteractionEnabled = false
            editCustField.isHidden = true
            editCustView.isHidden = true
    }

}
