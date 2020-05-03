//
//  ViewController.swift
//  Tutorial5
//
//  Created by Lindsay Wells.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{

    // a handle to the database itself
    // you can switch databases or create new blank ones by changing databaseName
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var raffleCID: UILabel!
    
    @IBOutlet weak var confirmedName: UITextField!
    @IBOutlet weak var desField: UITextField!
    @IBOutlet weak var ticketPrice: UITextField!
    @IBOutlet weak var endCon: UITextField!
    
    
    @IBOutlet weak var descriptInput: UITextView!
    @IBOutlet weak var chosenNameField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    

    @IBOutlet weak var colourBar2: UIImageView!
    @IBOutlet weak var colourBar1: UIImageView!
    @IBOutlet weak var colourField: UITextField!
    @IBOutlet weak var colourPicker: UIPickerView!
    @IBOutlet weak var idfield: UITextField!
    @IBOutlet weak var iDPicker: UIPickerView!

let rColour = ["Red", "Blue", "Green", "Yellow", "Brown", "Pink", "Orange"]
let rID = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"]

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 5 {
            print("tag is: ", pickerView.tag)
            return rID[row]
        } else {
            print("tag is: ", pickerView.tag)
            return rColour[row]
        }

    }
    */
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 5 {
            return NSAttributedString(string: rID[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            return NSAttributedString(string: rColour[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 5 {
            return rID.count
        } else {
            return rColour.count
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 5 {
            idfield.text = rID[row]
             raffleCID.text = idfield.text! + " - " + colourField.text!
            //print("tag is: ", pickerView.tag)
        } else {
            //print("tag is: ", pickerView.tag)
            colourField.text = rColour[row]
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            colourBar1.backgroundColor = colors[colourField.text!]
            colourBar2.backgroundColor = colors[colourField.text!]
            raffleCID.text = idfield.text! + " - " + colourField.text!
        }
        
    }
    
    @IBAction func showInputMenu(_ sender: UITextField) {
        colourField.isUserInteractionEnabled = false
        idfield.isUserInteractionEnabled = false
        chosenNameField.isUserInteractionEnabled = false
        desField.isUserInteractionEnabled = false
        ticketPrice.isUserInteractionEnabled = false
        endCon.isUserInteractionEnabled = false
        colourField.resignFirstResponder()
        idfield.resignFirstResponder()
        chosenNameField.resignFirstResponder()
        desField.resignFirstResponder()
        ticketPrice.resignFirstResponder()
        endCon.resignFirstResponder()
        if let opt = Options(tag: sender.tag) {
            //print (opt.options)
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
                confirmedName.keyboardType = UIKeyboardType.numberPad
                confirmedName.isUserInteractionEnabled = true
                confirmedName.isHidden = false
                confirmedName.becomeFirstResponder()
                let temp: String? = endCon.text
                confirmedName.text = temp
            } else if sender.tag == 5 {
                iDPicker.isHidden = false
                iDPicker.becomeFirstResponder()
                //let temp: String? = endCon.text
                //confirmedName.text = temp
            } else if sender.tag == 6 {
                colourPicker.isHidden = false
                colourPicker.becomeFirstResponder()
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
        idfield.isUserInteractionEnabled = true
        colourField.isUserInteractionEnabled = true
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
        } else if returnField == "Enter Ticket Sell Limit:" {
            confirmedName.isHidden = true
            let newName: String? = confirmedName.text
            endCon.text = newName
        } else if returnField == "Raffle ID:" {
            iDPicker.isHidden = true
        } else if returnField == "Raffle Colour:" {
            colourPicker.isHidden = true
        }
        popUpView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            confirmedName.keyboardType = UIKeyboardType.default
            chosenNameField.isUserInteractionEnabled = true
            desField.isUserInteractionEnabled = true
            ticketPrice.isUserInteractionEnabled = true
            endCon.isUserInteractionEnabled = true
            idfield.isUserInteractionEnabled = true
            colourField.isUserInteractionEnabled = true
            confirmedName.isUserInteractionEnabled = false
            descriptInput.isUserInteractionEnabled = false
            descriptInput.isHidden = true
            confirmedName.isHidden = true
            iDPicker.isHidden = true
            colourPicker.isHidden = true
            popUpView.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raffleCID.text = idfield.text! + " - " + colourField.text!
        let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
        UIColor.orange, "Blue": UIColor.blue,"Green":
        UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
        "Pink": UIColor.systemPink]
        colourBar1.backgroundColor = colors[colourField.text!]
        colourBar2.backgroundColor = colors[colourField.text!]
        
        //createTicketTable()
        
        database.insert(ticket:Ticket(open:1, name:"Debug Joe's Big BBQ", desc:"Wow ! its time for a big BBQ with Debug Joe yeehaw YEEEHAW",margin:0,price:1.99,iDLetter:"B",colour:1))
            
        database.insert(ticket:Ticket(open:1, name:"Debug Moe's Bigger BBQ", desc:"COME TO THE BIGGEST BBQ YET (WAY COOLER THAN JOES BBQ)",margin:1,price:4.99,iDLetter:"A",colour:2))

        print(database.selectAllTickets())
    }


}

