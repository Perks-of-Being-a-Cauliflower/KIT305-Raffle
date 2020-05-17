//
//  ViewController.swift
//  Tutorial5
//
//  Created by Lindsay Wells.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    // a handle to the database itself
    // you can switch databases or create new blank ones by changing databaseName
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    
    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var raffleCID: UILabel!
    
    @IBOutlet weak var confirmedName: UITextField!
    @IBOutlet weak var desField: UITextField!
    @IBOutlet weak var ticketPrice: UITextField!
    @IBOutlet weak var endCon: UITextField!
    
    @IBOutlet weak var marginSwitch: UISwitch!
    
    @IBOutlet weak var descriptInput: UITextView!
    @IBOutlet weak var chosenNameField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colourBar2: UIImageView!
    @IBOutlet weak var colourBar1: UIImageView!
    @IBOutlet weak var colourField: UITextField!
    @IBOutlet weak var colourPicker: UIPickerView!
    @IBOutlet weak var idfield: UITextField!
    @IBOutlet weak var iDPicker: UIPickerView!
    
    var imageSTR64: String?

    let rColour = ["Red", "Blue", "Green", "Yellow", "Brown", "Pink", "Orange"]
    let rID = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"]

    
    
    @IBAction func uploadPhoto(_ sender: Any) {
        if
        UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
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
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        print("first")
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage
        {
            //print("image is: ", image)
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            
            dismiss(animated: true, completion: nil)
            
            //let image : UIImage = imageView.image?.jpeg(UIImage.JPEGQuality(rawValue: 0)!)
            
            let image : UIImage = imageView.image!
            //let imageData:NSData = image.pngData()! as NSData
            let imageData = image.jpegData(compressionQuality: 0)
            let imageBase64String = imageData!.base64EncodedString()
            //print(imageBase64String ?? "Could not encode image to Base64")
            imageSTR64 = imageBase64String
            //imageSTR64 = imageData.base64EncodedString(options: .lineLength64Characters)
 
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func rowSelecter(targetField: UITextField, array: [String], targetPicker: UIPickerView) {
        //print("Hi")
        let finder = array.firstIndex(of: targetField.text!)
            //print(finder!)
            targetPicker.selectRow(finder ?? 0, inComponent: 0, animated: false)
            return
    }
    
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
    
    @IBAction func toggleMarginRaffle(_ sender: Any) {
        print(switchState(for: marginSwitch))
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
                rowSelecter(targetField: idfield, array: rID, targetPicker: iDPicker)
                //let temp: String? = endCon.text
                //confirmedName.text = temp
            } else if sender.tag == 6 {
                colourPicker.isHidden = false
                colourPicker.becomeFirstResponder()
                rowSelecter(targetField: colourField, array: rColour, targetPicker: colourPicker)
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
            
            
            if(database.selectTicketName(name: newName!) == nil){
                print("name does not exist")
                chosenNameField.text = newName
            }else{
                print("name does exist")
                let alert = UIAlertController(title: "Error:", message: "The name \"\(newName!)\" already exists in the database, please select another name", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
                
                chosenNameField.text = ""
            }
            
        } else if returnField == "Description:" {
            descriptInput.isHidden = true
            let newName: String? = descriptInput.text
            desField.text = newName
        } else if returnField == "Price:" {
            confirmedName.isHidden = true
            let newName: String? = confirmedName.text
            ticketPrice.text = newName
            if let ticketCost = Double(newName!) {
                print("The user entered a value price of \(ticketCost)")
                
            } else {
                print("Not a valid number: \(newName!)")
                ticketPrice.text = ""
            }
            //print(ticketPrice.text!)
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
    
    func switchState(for marginSwitch: UISwitch) -> Int {
        if marginSwitch.isOn {
            return 1
        } else {
            return 0
        }
    }
    
    @IBAction func startRaffle(_ sender: Any) {
        if(chosenNameField.text == ""){
            let alert = UIAlertController(title: "Whoops!", message: "Must Select a Raffle Name!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        if(desField.text == ""){
            let alert = UIAlertController(title: "Whoops!", message: "Must Select a Raffle Description!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        if(ticketPrice.text == "" ){
            let alert = UIAlertController(title: "Whoops!", message: "Must Select a Raffle Ticket Price!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        if(endCon.text == "" ){
            let alert = UIAlertController(title: "Whoops!", message: "Must Select a Maximum Number of Raffle Tickets!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
            return
        }
        /*if(imageSTR64 == nil ){
            return
        }*/

        
        
        performSegue(withIdentifier: "CreateRaffleSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
    if segue.identifier == "CreateRaffleSegue"
    {
        //createTicketTable()
        //print(chosenNameField.text!)
        //print(desField.text!)
        //print(ticketPrice.text!)
        //print("NUM 4 TICKET: \(Int32(endCon.text!)!)")
        //print(idfield.text!)
        //print(colourField.text!)
        
        
        let nextScreen = segue.destination as! SecondViewController
        nextScreen.nameFromPreviousView = chosenNameField.text
        //nextScreen.databaseFromPreviousView = database
        if let ticketCost = Double(ticketPrice.text!) {
            database.insertTicket(ticket:Ticket(open:1,
                                                name: chosenNameField.text!,
                                                desc:desField.text!,
                                                margin:Int32(switchState(for: marginSwitch!)),
                                                price:ticketCost,
                                                iDLetter:idfield.text!,
                                                colour:colourField.text!,
                                                maxTickets:Int32(endCon.text!)!,
                                                soldTickets:0,
                                                image: imageSTR64 ?? "na"
            ))
            let currentTicket = database.selectTicketName(name: chosenNameField.text!)
            nextScreen.idFromPreviousView = currentTicket!.ID
            chosenNameField.text = ""
            desField.text = ""
            ticketPrice.text = ""
            idfield.text = "A"
            colourField.text = "Red"
            endCon.text = ""
            raffleCID.text = idfield.text! + " - " + colourField.text!
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            colourBar1.backgroundColor = colors[colourField.text!]
            colourBar2.backgroundColor = colors[colourField.text!]
        } else {
            print("\nnot submitting: \(ticketPrice.text!)")
            ticketPrice.text = ""
        }
        //let nextScreen = segue.destination as! SecondViewController
        //nextScreen.nameFromPreviousView = confirmedName.text
        //nextScreen.colourFromPreviousView = colourBar1.backgroundColor ?? UIColor.white
        
    } }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        raffleCID.text = idfield.text! + " - " + colourField.text!
        let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
        UIColor.orange, "Blue": UIColor.blue,"Green":
        UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
        "Pink": UIColor.systemPink]
        colourBar1.backgroundColor = colors[colourField.text!]
        colourBar2.backgroundColor = colors[colourField.text!]
        

        
        
        /*
        database.insertTicket(ticket:Ticket(open:1, name:"Debug Moe's Bigger BBQ", desc:"COME TO THE BIGGEST BBQ YET (WAY COOLER THAN JOES BBQ)",margin:1,price:4.99,iDLetter:"A",colour:"green"))
        */
        
        /*let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd-MM-yyyy "
        let now = df.string(from: Date())
        
        database.insertCustomer(customer:Customer(ticketID: 0, ticketNum: 1, purchaseTime: now, refunded: 0, name: "Debug Joeseph", phone: 0456649912, email: "kennal@utas.edu.au"))
        
        database.insertCustomer(customer:Customer(ticketID: 1, ticketNum: 1, purchaseTime: now, refunded: 0, name: "Debug Moeseph", phone: 911, email: "notkennal@utas.edu.au"))
        
        print(database.selectAllCustomers()) */
    }


}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
