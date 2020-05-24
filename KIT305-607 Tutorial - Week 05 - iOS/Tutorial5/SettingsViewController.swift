//
//  SettingsViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
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
    
    @IBOutlet var soldTicketCounterSmall: UILabel!
    @IBOutlet var soldTicketCounterBig: UILabel!
    
    var imageSTR64: String?
    
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
    func rowSelecter() {
        print("Hi")
        let finder = cPicker.firstIndex(of: editColour.text!)
            print(finder!)
            colourPickerView.selectRow(finder!, inComponent: 0, animated: false)
            return
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        editColour.text = cPicker[row]
        let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
        UIColor.orange, "Blue": UIColor.blue,"Green":
        UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
        "Pink": UIColor.systemPink]
        firstColourBar.backgroundColor = colors[editColour.text!]
        secondColourBar.backgroundColor = colors[editColour.text!]
        settingsID.text = ticketData!.iDLetter + " - " + editColour.text!
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
                rowSelecter()
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
            
            if(database.selectTicketName(name: newName!) == nil){
                print("name does not exist")
                database.updateTicketName(ticketID: ticketID, newString: newName!)
                ticketTitle.text = newName
                changeNameField.text = newName
            }else{
                print("name does exist")
                let alert = UIAlertController(title: "Error:", message: "The name \"\(newName ?? " ")\" already exists in the database, please select another name", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
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
            let newColor: String? = editColour.text
            //editColour.text = newColor
            database.updateTicketColour(ticketID: ticketID, newString: newColor!)
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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
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
        editColour.text = ticket?.colour
        descriptionField.text = ticket!.desc
        endConField.text = String(ticket!.maxTickets)
        settingsID.text = ticket!.iDLetter + " - " + ticket!.colour
        // Do any additional setup after loading the view.
        ticketTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        let newString: String? = String(ticket!.soldTickets)
        let intCompare: Int = Int(ticket!.soldTickets)
        
        if intCompare == 0 {
            soldTicketCounterBig.text = "000"
            soldTicketCounterSmall.text = "000"
        } else if intCompare <= 9 {
            soldTicketCounterBig.text = "00" + newString!
            soldTicketCounterSmall.text = "00" + newString!
        } else if intCompare >= 10 && intCompare <= 99 {
            soldTicketCounterBig.text = "0" + newString!
            soldTicketCounterSmall.text = "0" + newString!
            } else {
            soldTicketCounterBig.text = newString!
            soldTicketCounterSmall.text = newString!
        }

        if(ticketData!.image != "na"){
            var newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               imageView.image = UIImage(data: newImageData)
            }
        }else{
            imageView.image = nil
        }
    }
    
    //updates counter after refunding tickets.
    override func viewWillAppear(_ animated: Bool) {
        let ticket = database.selectTicketBy(id: idFromPreviousView)
        ticketID = ticket!.ID
        ticketData = ticket
        ticketID = ticket!.ID
        
        let newString: String? = String(ticket!.soldTickets)
        let intCompare: Int = Int(ticket!.soldTickets)
        
        if intCompare == 0 {
            soldTicketCounterBig.text = "000"
            soldTicketCounterSmall.text = "000"
        } else if intCompare <= 9 {
            soldTicketCounterBig.text = "00" + newString!
            soldTicketCounterSmall.text = "00" + newString!
        } else if intCompare >= 10 && intCompare <= 99 {
            soldTicketCounterBig.text = "0" + newString!
            soldTicketCounterSmall.text = "0" + newString!
            } else {
            soldTicketCounterBig.text = newString!
            soldTicketCounterSmall.text = newString!
        }
        
        if(ticketData!.image != "na"){
            var newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               imageView.image = UIImage(data: newImageData)
            }
        }else{
            imageView.image = nil
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
       {
           print("first")
           if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage
           {
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
               
                dismiss(animated: true, completion: nil)
               
                let imageData = image.jpegData(compressionQuality: 0)
                let imageBase64String = imageData!.base64EncodedString()
                print("wew " + String(ticketID))
                let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
                database.updateTicketImage(ticketID: ticketID, newString: imageBase64String)
                print("weeew " + String(ticketID))
           }
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
       {
           dismiss(animated: true, completion: nil)
   }
    
    @IBAction func changePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        print("Library available")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
        print("No library available")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "TransferTicketArchive"
        {
            print("zing!")
            
            let nextScreen = segue.destination as! CustomerUITableViewController
            
            nextScreen.iDFromPreviousView = idFromPreviousView
            
        }
    }
}

