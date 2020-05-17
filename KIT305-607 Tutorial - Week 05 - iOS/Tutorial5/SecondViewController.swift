//
//  SecondViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit
import SQLite3

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    var ticketData: Ticket?
    

    @IBOutlet weak var ticketGoal: UITextField!
    @IBOutlet weak var colourBarTwo: UIImageView!
    @IBOutlet weak var colourBarOne: UIImageView!
    @IBOutlet var ticketName: UILabel!
    @IBOutlet var totalCost: UILabel!
    var nameFromPreviousView: String?
    var idFromPreviousView: Int32 = 0
    var colourFromPreviousView: UIColor? = UIColor.red
    var  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
    var winner: Customer?
    var allTickets: [Customer] = []
    //var databaseFromPreviousView: SQLiteDatabase?
    //var cTicket = Ticket?()
    
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var textInteractField: UITextField!
    @IBOutlet weak var popUpMenu2: UIView!
    @IBOutlet weak var numberToPurchaseField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ticketIdentifier: UILabel!
    @IBOutlet weak var ticketsSoldCounter: UILabel!
    
    @IBOutlet weak var winnerField: UITextField!
    @IBOutlet weak var imageField: UIImageView!
    
    
    
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerPhone: UITextField!
    @IBOutlet var customerEmail: UITextField!
    
    private let tPicker = ["1", "2", "3", "4", "5", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func rowSelecter() {
        //print("Hi")
        let finder = tPicker.firstIndex(of: numberToPurchaseField.text!)
            //print(finder!)
            pickerView.selectRow(finder!, inComponent: 0, animated: false)
            return
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            return NSAttributedString(string: tPicker[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return tPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberToPurchaseField.text = tPicker[row]
        let basePrice = Double(ticketData!.price)
        let nOfTickets = Double(numberToPurchaseField.text!)!
        let newCost = basePrice*nOfTickets
        let totePrice:String = String(format:"$ %.1f", newCost)
        totalCost.text = totePrice
    }
    
    @IBAction func drawWinner(_ sender: Any) {
        allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
        winner = allTickets.randomElement()
        //print(winner!.name)
        winnerField.text = winner?.name
    }
    
    @IBAction func winnerdetails(_ sender: Any) {
        winnerField.isUserInteractionEnabled = false
        if winnerField.text! != "" {
        let alert = UIAlertController(
            title: "Winner is " + winnerField.text! + "!",
            message: "Phone:  \(winner!.phone) \n Email: \(winner!.email)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Remove Ticket From Pool",
            style: .default,
            handler: { action in
                self.database.deleteCustomer(id: self.winner!.ID)
                let curr = self.winner?.ticketNum
                for customer in self.allTickets{
                    if(customer.ticketNum > curr!){
                        self.database.updateCustomerTicketNumber(ticketID: customer.ID, ticketNumber: customer.ticketNum-1)
                        //print("bumped down by 1")
                    }
                }
                self.ticketData?.soldTickets-=1
                self.database.updateSoldTickets(ticketID: self.ticketData!.ID, newNum: self.ticketData!.soldTickets)
                let newString: String? = String(self.ticketData!.soldTickets)
                let intCompare: Int = Int(self.ticketData!.soldTickets)
                
                if intCompare == 0 {
                    self.ticketsSoldCounter.text = "000"
                } else if intCompare <= 9 {
                    self.ticketsSoldCounter.text = "00" + newString!
                } else if intCompare >= 10 && intCompare <= 99 {
                    self.ticketsSoldCounter.text = "0" + newString!
                    } else {
                    self.ticketsSoldCounter.text = newString!
                }
                self.winnerField.text = ""
        }))
        alert.addAction(UIAlertAction(
            title: "Contact Winner",
            style: .default,
            handler: { action in
                
        }))
        alert.addAction(UIAlertAction(
            title: "Return",
            style: .default,
            handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
        winnerField.isUserInteractionEnabled = true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        //let ticket = databaseFromPreviousView!.selectTicketName(name: nameFromPreviousView!)
        let ticket = database.selectTicketBy(id: idFromPreviousView)
        ticketData = ticket
        //print(ticket!)
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
            ticketIdentifier.text = ticket!.iDLetter + " - " + ticket!.colour
            //ticketName.text = self.name
    
        }
        
    }
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(ticket?.name)
        
        //let ticket = databaseFromPreviousView!.selectTicketName(name: nameFromPreviousView!)
        let ticket = database.selectTicketBy(id: idFromPreviousView) 
        ticketData = ticket
        //print(ticket!)
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
            ticketIdentifier.text = ticket!.iDLetter + " - " + ticket!.colour
            //ticketName.text = self.name
            
            //print("return image string is: ", ticketData!.image)
            /*
            let dataDecoded:NSData = NSData(base64Encoded: ticketData!.image, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            */
            
            let newImageData = Data(base64Encoded: ticketData!.image)
            print("new data is: ", newImageData)
            if let newImageData = newImageData {
               imageField.image = UIImage(data: newImageData)
            }
            //imageField.image = decodedimage
             
            
            let newString: String? = String(ticketData!.soldTickets)
            let intCompare: Int = Int(ticketData!.soldTickets)
            
            if intCompare == 0 {
                ticketsSoldCounter.text = "000"
            } else if intCompare <= 9 {
                ticketsSoldCounter.text = "00" + newString!
            } else if intCompare >= 10 && intCompare <= 99 {
                ticketsSoldCounter.text = "0" + newString!
                } else {
                ticketsSoldCounter.text = newString!
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func showInputMenu(_ sender: UITextField) {
        customerName.isUserInteractionEnabled = false
        customerPhone.isUserInteractionEnabled = false
        customerEmail.isUserInteractionEnabled = false
        numberToPurchaseField.isUserInteractionEnabled = false
        customerEmail.resignFirstResponder()
        customerPhone.resignFirstResponder()
        customerName.resignFirstResponder()
        numberToPurchaseField.resignFirstResponder()
        //print(sender.tag)
            if sender.tag == 1 {
                ticketLabel.text = "Name: "
                textInteractField.isUserInteractionEnabled = true
                textInteractField.isHidden = false
                textInteractField.becomeFirstResponder()
                let temp: String? = customerName.text
                textInteractField.text = temp
            } else if sender.tag == 2 {
                ticketLabel.text = "Phone: "
                textInteractField.keyboardType = UIKeyboardType.numberPad
                textInteractField.isUserInteractionEnabled = true
                textInteractField.isHidden = false
                textInteractField.becomeFirstResponder()
                let temp: String? = customerPhone.text
                textInteractField.text = temp
            } else if sender.tag == 3 {
                ticketLabel.text = "Email: "
                textInteractField.isUserInteractionEnabled = true
                textInteractField.isHidden = false
                textInteractField.becomeFirstResponder()
                let temp: String? = customerEmail.text
                textInteractField.text = temp
            } else if sender.tag == 4 {
                pickerView.isHidden = false
                pickerView.becomeFirstResponder()
                rowSelecter()
                ticketLabel.text = "Tickets to Purchase: "
            }
            popUpMenu2.isHidden = false
        }
    
    @IBAction func confirmDetailsButton(_ sender: Any) {
        let returnField: String? = ticketLabel.text
        textInteractField.isUserInteractionEnabled = false
        customerEmail.isUserInteractionEnabled = true
        customerPhone.isUserInteractionEnabled = true
        customerName.isUserInteractionEnabled = true
        numberToPurchaseField.isUserInteractionEnabled = true
        if returnField == "Name: " {
            textInteractField.isHidden = true
            let newName: String? = textInteractField.text
            customerName.text = newName
        } else if returnField == "Phone: " {
            textInteractField.isHidden = true
            let newName: String? = textInteractField.text
            customerPhone.text = newName
            if let phoneN = Int(newName!) {
                print("The user entered a value price of \(phoneN)")
                
            } else {
                print("Not a valid number: \(newName!)")
                customerPhone.text = ""
            }
            //print(customerPhone.text!)
            textInteractField.keyboardType = UIKeyboardType.default
        } else if returnField == "Email: " {
            textInteractField.isHidden = true
            let newName: String? = textInteractField.text
            customerEmail.text = newName
        } else if returnField == "Tickets to Purchase: " {
            pickerView.isHidden = true
        }
        popUpMenu2.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            textInteractField.keyboardType = UIKeyboardType.default
            customerEmail.isUserInteractionEnabled = true
            customerPhone.isUserInteractionEnabled = true
            customerName.isUserInteractionEnabled = true
            numberToPurchaseField.isUserInteractionEnabled = true
            textInteractField.isUserInteractionEnabled = false
            textInteractField.isHidden = true
            pickerView.isHidden = true
            popUpMenu2.isHidden = true
    }
    
    
    @IBAction func AddCustomer(_ sender: Any) {
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase")
        
        if(ticketData == nil){
            print("found lost name")
            ticketData = database.selectTicketName(name: nameFromPreviousView!)
        }
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd-MM-yyyy "
        let now = df.string(from: Date())
        
        //currently just works with selling one ticket, need to make it look for the lowest unallocated value, as well as the ability to sell multiple tickets.
        //print(ticketData!.name)
        let num = Int32(numberToPurchaseField.text!)
        let curr = ticketData!.soldTickets
        
        for i in stride(from: 1, to: (num! + 1), by: 1) {
            //print(i+1)
            
            
            database.insertCustomer(customer:Customer(ticketID: ticketData?.ID ?? -1,
                                                    ticketNum: curr + i,
                                                    purchaseTime: now,
                                                    refunded: 0,
                                                    name: customerName.text!,
                                                    phone: Int32(customerPhone.text ?? "") ?? -1,
                                                    email: customerEmail.text ?? ""))
        }
        
        ticketData!.soldTickets = curr + num!
        database.updateSoldTickets(ticketID: ticketData!.ID, newNum: ticketData!.soldTickets)
        
        let newString: String? = String(ticketData!.soldTickets)
        let intCompare: Int = Int(ticketData!.soldTickets)
        
        if intCompare == 0 {
            ticketsSoldCounter.text = "000"
        } else if intCompare <= 9 {
            ticketsSoldCounter.text = "00" + newString!
        } else if intCompare >= 10 && intCompare <= 99 {
            ticketsSoldCounter.text = "0" + newString!
            } else {
            ticketsSoldCounter.text = newString!
        }
        

        /*
                database.updateSoldTickets(ticketID: ticketData!.ID, newNum: num)
        //impliment a way to increase and track ticket numbers. via ticket SQL
            //also need to impliment a way to sell multiple tickets via a stepper. 
        database.insertCustomer(customer:Customer(ticketID: ticketData?.ID ?? -1,
                                                  ticketNum: num,
                                                  purchaseTime: now,
                                                  refunded: 0,
                                                  name: customerName.text!,
                                                  phone: Int32(customerPhone.text ?? "") ?? -1,
                                                  email: customerEmail.text ?? ""))
        */
        //print("added Customer")
        customerName.text = ""
        customerPhone.text = ""
        customerEmail.text = ""
        //print(database.selectAllCustomers())
    }
    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "TransferToTicketEdit"
           {
               //createTicketTable()
                //print("zong!")
               
                let nextScreen = segue.destination as! SettingsViewController

                nextScreen.idFromPreviousView = idFromPreviousView
                /*
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

}
