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
    var idFromPreviousView: Int32 = 0
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
            database.updateTicketName(ticketID: ticketID, newString: newName!)
            ticketTitle.text = newName
        } else if returnField == "Edit Raffle Description: " {
            descEditField.isHidden = true
            let newName: String? = descEditField.text
            descriptionField.text = newName
            database.updateTicketDesc(ticketID: ticketID, newString: newName!)
        } else if returnField == "Edit Raffle Ticket Goal: " {
            editField.isHidden = true
            let newName: String? = editField.text
            endConField.text = newName
            database.updateMaxTickets(ticketID: ticketID, newNum: Int32(newName!)!)
            editField.keyboardType = UIKeyboardType.default
        } else if returnField == "Edit Colour: " {
            colourPickerView.isHidden = true
            database.updateTicketColour(ticketID: ticketID, newString: editColour.text!)
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
        let ticket = database.selectTicketBy(id: idFromPreviousView)
        ticketID = ticket!.ID
        ticketData = ticket
        ticketID = ticket!.ID
        ticketTitle.text = ticket!.name
        changeNameField.text = ticket!.name
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
            
            nextScreen.iDFromPreviousView = idFromPreviousView
            
        }
            /*
        else if segue.identifier == "SaveAndExit"
        {
            print("zip!")
            let nextScreen = segue.destination as! SecondViewController
            let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
            
            ticketData = database.selectTicketName(name: nameFromPreviousView!)
            
            if(changeNameField.text != ""){
                ticketData?.name = changeNameField.text!
            }
            if(descriptionField.text != ""){
                ticketData?.desc = descriptionField.text!
            }
            if(endConField.text != ""){
                ticketData?.maxTickets = Int32(endConField.text!)!
            }
            //@IBOutlet var ticketName: UITextField!
            //@IBOutlet var ticketDescription: UITextField!
            //@IBOutlet var endCondition: UITextField!
            
                //updated the other stuff, but commenting this out since we are going with wills
                //database.updateTicketInfo(ticket: ticketData!)
            
                //nextScreen.nameFromPreviousView = ticketData?.name
            
            nextScreen.nameFromPreviousView = ticket?.name
            
            let updateStatementQuery = "UPDATE Ticket SET soldTickets = " + String(newNum) + " WHERE id = " + String(ticketID) + ";"
            
            updateWithQuery(updateStatementQuery,
            bindingFunction: { (updateStatement) in
                sqlite3_bind_int(updateStatement, 9, newNum)
            })*/
            
            //need to do the update shit
            
            //nextScreen.nameFromPreviousView = nameFromPreviousView
        }
        
        
    
    /*// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
