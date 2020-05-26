//
//  SettingsViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Will Colbert. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    @IBOutlet weak var updateImageViewer: UIImageView!
    @IBOutlet var ticketTitle: UILabel!
    var nameFromPreviousView: String?
    var idFromPreviousView: Int32 = 0
    var ticketData: Ticket?
    var ticketID: Int32 = 0
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase2")
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
    
    @IBOutlet weak var soldPicker1: UIPickerView!
    @IBOutlet weak var soldPicker2: UIPickerView!
    @IBOutlet weak var loneID: UILabel!
    
    
    var imageSTR64: String?
    
    private let cPicker = ["Red", "Blue", "Green", "Yellow", "Brown", "Pink", "Orange"]
    private let nPicker = Array(0...999)
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            return NSAttributedString(string: cPicker[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        } else if pickerView.tag == 2 {
            let intCompare: Int = nPicker[row]
            let intCompString = String(intCompare)
            let finalString: String
            
            if intCompare == 0 {
                finalString = "000"
            } else if intCompare <= 9 {
                finalString = "00" + intCompString
            } else if intCompare >= 10 && intCompare <= 99 {
                finalString = "0" + intCompString
                } else {
                finalString = intCompString
            }
            return NSAttributedString(string: finalString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            return NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }
    
    func ticketTicker(targetField: Ticket, array: [Int], targetPicker: UIPickerView) {
        let finder = array.firstIndex(of: Int(targetField.soldTickets))
            targetPicker.selectRow(finder!, inComponent: 0, animated: true)
            return
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView.tag == 1 {
                return cPicker.count
            } else {
                return nPicker.count
            }
    }
    func rowSelecter(targetField: UITextField, array: [String], targetPicker: UIPickerView) {
        let finder = array.firstIndex(of: targetField.text!)
            targetPicker.selectRow(finder!, inComponent: 0, animated: false)
            return
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
        editColour.text = cPicker[row]
        let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
        UIColor.orange, "Blue": UIColor.blue,"Green":
        UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
        "Pink": UIColor.systemPink]
        firstColourBar.backgroundColor = colors[editColour.text!]
        secondColourBar.backgroundColor = colors[editColour.text!]
        settingsID.text = ticketData!.iDLetter + " - " + editColour.text!
        }
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
                rowSelecter(targetField: editColour, array: cPicker, targetPicker: colourPickerView)
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
        editColour.text = ticket?.colour
        descriptionField.text = ticket!.desc
        endConField.text = String(ticket!.maxTickets)
        settingsID.text = ticket!.colour + " - " + ticket!.iDLetter
        loneID.text = ticket!.iDLetter
        // Do any additional setup after loading the view.
        ticketTitle.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker1)
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker2)

        if(ticketData!.image != "na"){
            let newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               updateImageViewer.image = UIImage(data: newImageData)
            }
        }else{
            updateImageViewer.image = nil
        }
    }
    
    //updates couletr after refunding tickets.
    override func viewWillAppear(_ animated: Bool) {
        let ticket = database.selectTicketBy(id: idFromPreviousView)
        ticketID = ticket!.ID
        ticketData = ticket
        
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker1)
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker2)
        
        settingsID.text = ticket!.colour + " - " + ticket!.iDLetter
        loneID.text = ticket!.iDLetter
        
        if(ticketData!.image != "na"){
            let newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               updateImageViewer.image = UIImage(data: newImageData)
            }
        }else{
            updateImageViewer.image = nil
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
       {
           if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage
           {
            
            updateImageViewer.contentMode = .scaleAspectFit
            updateImageViewer.image = image
            
            
            dismiss(animated: true, completion: nil)
            
            let image : UIImage = updateImageViewer.image!
            let imageData = image.pngData()
            let imageBase64String = imageData!.base64EncodedString()
            imageSTR64 = imageBase64String
            print("ticket id going in: ", ticketID)
            print("image going in is: ", imageBase64String.prefix(40))
            //database.updateTicketImage(ticketID: ticketID, newString: "test")
            database.updateTicketImage(ticketID: ticketID, newString: imageBase64String)
            ticketData = database.selectTicketBy(id: ticketID)!
            print("image coming out is: ", ticketData!.image.prefix(40))
            print("ticket id coming out: ", ticketData!.ID)
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
            let nextScreen = segue.destination as! CustomerUITableViewController
            
            nextScreen.iDFromPreviousView = idFromPreviousView
            
        }
    }
}

