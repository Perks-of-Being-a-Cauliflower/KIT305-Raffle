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
    var ticketsToSell: Set<Int> = []
    var soldTick: Set<Int> = []
    //var databaseFromPreviousView: SQLiteDatabase?
    //var cTicket = Ticket?()
    
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var textInteractField: UITextField!
    @IBOutlet weak var popUpMenu2: UIView!
    @IBOutlet weak var numberToPurchaseField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ticketIdentifier: UILabel!
    @IBOutlet weak var ticketsSoldCounter: UILabel!
    @IBOutlet weak var userguide: UILabel!
    
    @IBOutlet weak var winnerField: UITextField!
    //@IBOutlet weak var imageField: UIImageView!
    
    @IBOutlet var ticketsField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    
    @IBOutlet var soldTicketCounterSmall: UILabel!
    
    
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerPhone: UITextField!
    @IBOutlet var customerEmail: UITextField!
    
    var ableToClose = false
    
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
        if ticketData?.margin == 1 {
            if winnerField.text! != "" {
                winner = nil
                allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
                let winningNum = Int32(winnerField.text!)
                print("Winning num is: ", winningNum)
                for ticketN in allTickets {
                    print("current id: ", ticketN.ticketNum)
                    if ticketN.ticketNum == winningNum {
                        winner = ticketN
                    }
                }
                if winner != nil {
                    ableToClose = true
                    let alert = UIAlertController(
                        title: "Winner is " + winner!.name + "!",
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
                            self.soldTicketCounterSmall.text = self.ticketsSoldCounter.text
                            self.winnerField.text = "Please Enter Margin Value"
                            self.winnerField.textColor = UIColor.lightGray
                            
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
                } else {
                    let alert = UIAlertController(
                        title: "No Winner!",
                        message: "No one had the Margin Value", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(
                        title: "Return",
                        style: .default,
                        handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            
            }
        } else {
            ableToClose = true
            allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
            winner = allTickets.randomElement()
            //print(winner!.name)
            if winner?.name != nil {
            winnerField.text = winner!.name
                userguide.isHidden = false
            winnerField.isUserInteractionEnabled = true
            } else {
                winnerField.text = "No Tickets Sold"
                winnerField.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBAction func winnerdetails(_ sender: Any) {
        
        if ticketData?.margin == 1 {
            textViewDidBeginEditing(winnerField)
            self.winnerField.text = "Please Enter Margin Value"
            
        } else {
        
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
                    self.soldTicketCounterSmall.text = "000"
                } else if intCompare <= 9 {
                    self.ticketsSoldCounter.text = "00" + newString!
                    self.soldTicketCounterSmall.text = "00" + newString!
                } else if intCompare >= 10 && intCompare <= 99 {
                    self.ticketsSoldCounter.text = "0" + newString!
                    self.soldTicketCounterSmall.text = "0" + newString!
                    } else {
                    self.ticketsSoldCounter.text = newString!
                    self.soldTicketCounterSmall.text = newString!
                }
                self.winnerField.text = ""
                self.userguide.isHidden = true
                self.winnerField.isUserInteractionEnabled = false
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
            self.performSegue(withIdentifier: "returnToCreatePageIfNoTicket", sender: self)
            let alert = UIAlertController(title: "Warning:", message: "Cannot enter sell page for a deleted ticket", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { action in
                //run your function here
                return
            }))
            
            self.present(alert, animated: true)
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
            
            let newString: String? = String(ticketData!.soldTickets)
            let intCompare: Int = Int(ticketData!.soldTickets)
            
            
            if intCompare == 0 {
                ticketsSoldCounter.text = "000"
                soldTicketCounterSmall.text = "000"
            } else if intCompare <= 9 {
                ticketsSoldCounter.text = "00" + newString!
                soldTicketCounterSmall.text = "00" + newString!
            } else if intCompare >= 10 && intCompare <= 99 {
                ticketsSoldCounter.text = "0" + newString!
                soldTicketCounterSmall.text = "0" + newString!
                } else {
                ticketsSoldCounter.text = newString!
                soldTicketCounterSmall.text = newString!
            }
            
            descriptionField.text = ticketData!.desc
            ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)
            if ticketData?.margin == 1 {
                winnerField.text = "Please Enter Margin Value"
                winnerField.textColor = UIColor.lightGray
                winnerField.isUserInteractionEnabled = true
            } else {
                winnerField.isUserInteractionEnabled = false
            }
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
            descriptionField.layer.borderWidth = 1.0
            let descolour = UIColor.lightGray.cgColor
            descriptionField.layer.borderColor = descolour
            
            //print("return image string is: ", ticketData!.image)
            /*
            let dataDecoded:NSData = NSData(base64Encoded: ticketData!.image, options: NSData.Base64DecodingOptions(rawValue: 0))!
            let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
            */
            if ticketData?.margin == 1 {
                winnerField.isUserInteractionEnabled = true
                winnerField.text = "Please Enter Margin Value"
                winnerField.textColor = UIColor.lightGray
            } else {
                winnerField.isUserInteractionEnabled = false
            }
            
            
        if(ticketData!.image != "na"){
            //no longer have image on sell screen.
            /*var newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               //imageField.image = UIImage(data: newImageData)
            }
            
            
            newImageData = Data(base64Encoded: ticketData!.image)
            //print("new data is: ", newImageData)
            if let newImageData = newImageData {
               //imageField.image = UIImage(data: newImageData)
                if(ticketData!.image != "na"){
                    let newImageData = Data(base64Encoded: ticketData!.image)
                    //print("new data is: ", newImageData)
                    if let newImageData = newImageData {
                       //imageField.image = UIImage(data: newImageData)
                    }
                }
            }*/
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
        
        descriptionField.text = ticketData!.desc
        ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)
    }
    }
    
    func textViewDidBeginEditing(_ textView: UITextField) {
        if textView.textColor == UIColor.lightGray {
            //textView.text = ""
            textInteractField.text = ""
        } else {
            let temp: String? = winnerField.text
            textInteractField.text = temp
        }
            textView.isUserInteractionEnabled = false
            textView.resignFirstResponder()
            ticketLabel.text = "Enter Margin Value:"
            textInteractField.isUserInteractionEnabled = true
            textInteractField.isHidden = false
            textInteractField.becomeFirstResponder()
            textInteractField.keyboardType = UIKeyboardType.numberPad
            
            if winnerField.text == "Please Enter Margin Value" {
                textInteractField.text = ""
            }
            popUpMenu2.isHidden = false
            
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
        winnerField.isUserInteractionEnabled = true
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
        } else if returnField == "Enter Margin Value:" {
            if textInteractField.text == "" {
                winnerField.text = "Please Enter Margin Value"
                winnerField.textColor = UIColor.lightGray
            } else {
                let newName: String? = textInteractField.text
                winnerField.text = newName
                textInteractField.keyboardType = UIKeyboardType.default
                winnerField.textColor = UIColor.black
                textInteractField.isHidden = true
            }
        }
        popUpMenu2.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
            textInteractField.keyboardType = UIKeyboardType.default
            if winnerField.text == "Please Enter Margin Value" {
                winnerField.textColor = UIColor.lightGray
            }
            customerEmail.isUserInteractionEnabled = true
            customerPhone.isUserInteractionEnabled = true
            customerName.isUserInteractionEnabled = true
            numberToPurchaseField.isUserInteractionEnabled = true
            winnerField.isUserInteractionEnabled = true
            textInteractField.isUserInteractionEnabled = false
            textInteractField.isHidden = true
            pickerView.isHidden = true
            popUpMenu2.isHidden = true
    }
    
    func AddCustomerConfirmed(){
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
            if ticketData?.margin == 0 {
            database.insertCustomer(customer:Customer(ticketID: ticketData?.ID ?? -1,
                                                    ticketNum: curr + i,
                                                    purchaseTime: now,
                                                    refunded: 0,
                                                    name: customerName.text!,
                                                    phone: Int32(customerPhone.text ?? "") ?? -1,
                                                    email: customerEmail.text ?? ""))
        
            } else {
                let soldTicket = Int32(marginRand())
                database.insertCustomer(customer:Customer(ticketID: ticketData?.ID ?? -1,
                                                            ticketNum: soldTicket,
                                                            purchaseTime: now,
                                                            refunded: 0,
                                                            name: customerName.text!,
                                                            phone: Int32(customerPhone.text ?? "") ?? -1,
                                                            email: customerEmail.text ?? ""))
                
            }
        }
        ticketData!.soldTickets = curr + num!
        database.updateSoldTickets(ticketID: ticketData!.ID, newNum: ticketData!.soldTickets)
        
        let newString: String? = String(ticketData!.soldTickets)
        let intCompare: Int = Int(ticketData!.soldTickets)
        
        if intCompare == 0 {
            ticketsSoldCounter.text = "000"
            soldTicketCounterSmall.text = "000"
        } else if intCompare <= 9 {
            ticketsSoldCounter.text = "00" + newString!
            soldTicketCounterSmall.text = "00" + newString!
        } else if intCompare >= 10 && intCompare <= 99 {
            ticketsSoldCounter.text = "0" + newString!
            soldTicketCounterSmall.text = "0" + newString!
            } else {
            ticketsSoldCounter.text = newString!
            soldTicketCounterSmall.text = newString!
        }
        
        ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)

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
        numberToPurchaseField.text = tPicker[0]
    }
    
    func marginRand ()-> Int {
        allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
        for i in 1 ... ticketData!.maxTickets {
            ticketsToSell.insert(Int(i))
        }
        for tickets in allTickets{
            soldTick.insert(Int(tickets.ticketNum))
        }
        let ticketsLeft = ticketsToSell.subtracting(soldTick)
        return ticketsLeft.randomElement()!
    }
    
    @IBAction func AddCustomer(_ sender: Any) {
        let num = Int32(numberToPurchaseField.text!)
        let curr = ticketData!.soldTickets
        var max = false
        
        if(num! + curr > ticketData!.maxTickets){
            max = true
            print("Exceed max tickets")
            let alert = UIAlertController(title: "Max Tickets:", message: "This transaction would exceed the maximum ticket amount!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { action in
                //run your function here
                return
            }))
            
            self.present(alert, animated: true)
        }
        if(!max){
            let alert = UIAlertController(title: "Confirm:", message: "Currently about to sell \(num ?? 0) tickets for \(String(self.totalCost.text ?? "$$"))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm!", style: .default, handler: { action in
                //run your function here
                self.AddCustomerConfirmed()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                //run your function here
                return
            }))
            
            self.present(alert, animated: true)
            
        }
        
        
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
    @IBAction func closeRaffle(_ sender: Any) {
        print("pressedClose")
        
        if(ticketData?.soldTickets == 0 || ableToClose == true){
            let alert = UIAlertController(title: "Warning:", message: "You are about to perminantly delete \(ticketData?.name ?? "the raffle")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in
                //run your function hered
                
                self.database.deleteRaffle(id: self.ticketData!.ID)
                //self.tabBarController!.selectedIndex = 0
                
                self.performSegue(withIdentifier: "returnToLibraryPostDeletion", sender: self)
                
                //self.tabBarController!.selectedIndex = 1
                
                return
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                //run your function here
                return
            }))
            
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: "Warning:", message: "Cannot delete \(ticketData?.name ?? "the raffle") until a winner has been drawn", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                //run your function here
                return
            }))
            
            self.present(alert, animated: true)
        }
    }
    

}
