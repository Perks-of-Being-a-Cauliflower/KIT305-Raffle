//
//  SettingsViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var ticketTitle: UILabel!
    var nameFromPreviousView: String?
    var ticketData: Ticket?
    var ticketID: Int32 = 0
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    @IBOutlet weak var settingsID: UILabel!
    @IBOutlet weak var endConField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    //var colourFromPreviousView: UIColor? = UIColor.red
    @IBOutlet weak var changeNameField: UITextField!
    @IBOutlet weak var firstColourBar: UIImageView!
    @IBOutlet weak var secondColourBar: UIImageView!
    @IBOutlet weak var editColour: UITextField!
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var editField: UITextField!
    @IBOutlet weak var popUpTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var colourPickerView: UIPickerView!
    @IBOutlet weak var descEditField: UITextView!
    
    
    private let cPicker = ["Red", "Blue", "Green", "Yellow", "Brown", "Pink", "Orange"]

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            return NSAttributedString(string: cPicker[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editColour.text = cPicker[row]
        
    }
    
    @IBAction func showInputMenu(_ sender: UITextField) {
        changeNameField.isUserInteractionEnabled = false
        descriptionField.isUserInteractionEnabled = false
        endConField.isUserInteractionEnabled = false
        editColour.isUserInteractionEnabled = false
        changeNameField.resignFirstResponder()
        descriptionField.resignFirstResponder()
        endConField.resignFirstResponder()
        editColour.resignFirstResponder()
        print(sender.tag)
            if sender.tag == 1 {
                popUpTitle.text = "Edit Raffle Name: "
                editField.isUserInteractionEnabled = true
                editField.isHidden = false
                editField.becomeFirstResponder()
                let temp: String? = changeNameField.text
                editField.text = temp
            } else if sender.tag == 2 {
                popUpTitle.text = "Edit Raffle Description: "
                descEditField.isUserInteractionEnabled = true
                descEditField.isHidden = false
                descEditField.becomeFirstResponder()
                let temp: String? = descriptionField.text
                descEditField.text = temp
            } else if sender.tag == 3 {
                popUpTitle.text = "Edit Raffle Ticket Goal: "
                editField.keyboardType = UIKeyboardType.numberPad
                editField.isUserInteractionEnabled = true
                editField.isHidden = false
                editField.becomeFirstResponder()
                let temp: String? = endConField.text
                editField.text = temp
            } else if sender.tag == 4 {
                colourPickerView.isHidden = false
                colourPickerView.becomeFirstResponder()
                popUpTitle.text = "Edit Colour: "
            }
            popUpView.isHidden = false
        }
    
    @IBAction func confirmDetailsButton(_ sender: Any) {
        let returnField: String? = popUpTitle.text
        editField.isUserInteractionEnabled = false
        descEditField.isUserInteractionEnabled = false
        changeNameField.isUserInteractionEnabled = true
        descriptionField.isUserInteractionEnabled = true
        endConField.isUserInteractionEnabled = true
        editColour.isUserInteractionEnabled = true
        if returnField == "Edit Raffle Name: " {
            editField.isHidden = true
            let newName: String? = editField.text
            changeNameField.text = newName
            database.updateTicketName(ticketID: ticketID, newName: newName!)
            ticketTitle.text = newName
        } else if returnField == "Edit Raffle Description: " {
            descEditField.isHidden = true
            let newName: String? = editField.text
            descriptionField.text = newName
        } else if returnField == "Edit Raffle Ticket Goal: " {
            editField.isHidden = true
            let newName: String? = editField.text
            endConField.text = newName
            editField.keyboardType = UIKeyboardType.default
        } else if returnField == "Edit Colour: " {
            colourPickerView.isHidden = true
        }
        popUpView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            editField.keyboardType = UIKeyboardType.default
            changeNameField.isUserInteractionEnabled = true
            descriptionField.isUserInteractionEnabled = true
            endConField.isUserInteractionEnabled = true
            editColour.isUserInteractionEnabled = true
            editField.isUserInteractionEnabled = false
            editField.isHidden = true
            descEditField.isUserInteractionEnabled = false
            descEditField.isHidden = true
            colourPickerView.isHidden = true
            popUpView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        //let ticket = databaseFromPreviousView!.selectTicketName(name: nameFromPreviousView!)
        let ticket = database.selectTicketName(name: nameFromPreviousView!)
        ticketID = ticket!.ID
        ticketData = ticket
        ticketID = ticket!.ID
        ticketTitle.text = nameFromPreviousView!
        changeNameField.text = nameFromPreviousView!
        let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
        UIColor.orange, "Blue": UIColor.blue,"Green":
        UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
        "Pink": UIColor.systemPink]
        firstColourBar.backgroundColor = colors[ticket!.colour]
        secondColourBar.backgroundColor = colors[ticket!.colour]
        print(ticket!.maxTickets)
        descriptionField.text = ticket!.desc
        endConField.text = String(ticket!.maxTickets)
        settingsID.text = ticket!.iDLetter + " - " + ticket!.colour
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
        

        
        /*nextScreen.nameFromPreviousView = chosenNameField.text
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
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
