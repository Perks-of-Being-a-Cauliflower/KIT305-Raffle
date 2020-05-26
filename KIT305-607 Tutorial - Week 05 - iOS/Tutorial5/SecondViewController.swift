//
//  SecondViewController.swift
//  Tutorial5
//
//  Created by Will Colbert on 25/4/20.
//  Copyright © 2020 Will Colbert. All rights reserved.
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
    var  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase2")
    var winner: Customer?
    var allTickets: [Customer] = []
    var ticketsToSell: Set<Int> = []
    var soldTick: Set<Int> = []
    var newSet: Set<Int> = []
    
    @IBOutlet weak var ticketLabel: UILabel!
    @IBOutlet weak var textInteractField: UITextField!
    @IBOutlet weak var popUpMenu2: UIView!
    @IBOutlet weak var numberToPurchaseField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ticketIdentifier: UILabel!
    @IBOutlet weak var userguide: UILabel!
    @IBOutlet weak var rightID: UILabel!
    
    @IBOutlet weak var winnerField: UITextField!
    
    @IBOutlet var ticketsField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    
    
    
    @IBOutlet weak var soldpicker2: UIPickerView!
    @IBOutlet weak var soldPicker: UIPickerView!
    @IBOutlet var customerName: UITextField!
    @IBOutlet var customerPhone: UITextField!
    @IBOutlet var customerEmail: UITextField!
    
    var ableToClose = false
    
    private let tPicker = Array(1...100)
    
    private let nPicker = Array(0...999)

    // see viewController.swift for pickerView References
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // see viewController.swift for pickerView References
    func ticketTicker(targetField: Ticket, array: [Int], targetPicker: UIPickerView) {
        let finder = array.firstIndex(of: Int(targetField.soldTickets))
            targetPicker.selectRow(finder!, inComponent: 0, animated: true)
            return
    }
    // see viewController.swift for pickerView References
    func ticketPickerSet(targetField: UITextField, array: [Int], targetPicker: UIPickerView) {
        let finder = array.firstIndex(of: Int(targetField.text!)!)
            targetPicker.selectRow(finder!, inComponent: 0, animated: false)
            return
    }
    // see viewController.swift for pickerView References
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent
        component: Int) -> NSAttributedString? {
        if pickerView.tag == 1 {
            return NSAttributedString(string: String(tPicker[row]), attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
    
    // see viewController.swift for pickerView References
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return tPicker.count
        } else {
            return nPicker.count
        }
    }
    // see viewController.swift for pickerView References
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
        numberToPurchaseField.text = String(tPicker[row])
        let basePrice = Double(ticketData!.price)
        let nOfTickets = Double(numberToPurchaseField.text!)!
        let newCost = basePrice*nOfTickets
        let totePrice:String = String(format:"$ %.1f", newCost)
        totalCost.text = totePrice
        }
    }
    
    
    @IBAction func drawWinner(_ sender: Any) {
        if ticketData?.margin == 1 {
            if winnerField.text! != "Please Enter Margin Value" {
                winner = nil
                allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
                let winningNum = Int32(winnerField.text!)
                print("Winning num is: ", winningNum!)
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
                            
                            self.ticketData?.soldTickets-=1
                            self.database.updateSoldTickets(ticketID: self.ticketData!.ID, newNum: self.ticketData!.soldTickets)
                            
                            self.ticketTicker(targetField: self.ticketData!, array: self.nPicker, targetPicker: self.soldpicker2)
                            self.ticketTicker(targetField: self.ticketData!, array: self.nPicker, targetPicker: self.soldPicker)
                            self.ticketsField.text = String(self.ticketData!.soldTickets) + "/" + String(self.ticketData!.maxTickets)
                            
                            self.winnerField.text = "Please Enter Margin Value"
                            self.winnerField.textColor = UIColor.lightGray
                            
                    }))
                    alert.addAction(UIAlertAction(
                        title: "Share",
                        style: .default,
                        handler: { action in
                            self.contactWinner(ticket: self.ticketData!, winner: self.winner!)
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
                    ableToClose = true
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
                self.ticketData?.soldTickets-=1
                self.database.updateSoldTickets(ticketID: self.ticketData!.ID, newNum: self.ticketData!.soldTickets)
                
                self.ticketTicker(targetField: self.ticketData!, array: self.nPicker, targetPicker: self.soldpicker2)
                self.ticketTicker(targetField: self.ticketData!, array: self.nPicker, targetPicker: self.soldPicker)
                
                self.ticketsField.text = String(self.ticketData!.soldTickets) + "/" + String(self.ticketData!.maxTickets)
                self.winnerField.text = ""
                self.userguide.isHidden = true
                self.winnerField.isUserInteractionEnabled = false
        }))
        alert.addAction(UIAlertAction(
            title: "Share",
            style: .default,
            handler: { action in
                self.contactWinner(ticket: self.ticketData!, winner: self.winner!)
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
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase2")
        let ticket = database.selectTicketBy(id: idFromPreviousView)
        ticketData = ticket
        print("image coming out is: ", ticket!.image.prefix(40))
        if(ticket == nil){
            print("ticket nil")
            self.performSegue(withIdentifier: "returnToCreatePageIfNoTicket", sender: self)
        }else{
            print("ticket not nil")
            ticketName.text = ticket?.name
            ticketName.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            let totePrice:String = String(format:"$ %.1f", ticket!.price)
            totalCost.text = totePrice
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            colourBarOne.backgroundColor = colors[ticket!.colour]
            colourBarTwo.backgroundColor = colors[(ticket?.colour)!]
            ticketIdentifier.text = ticket!.colour + " - " + ticket!.iDLetter
            rightID.text = ticket!.iDLetter
            
            ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldpicker2)
            ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker)
            
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
        let ticket = database.selectTicketBy(id: idFromPreviousView) 
        ticketData = ticket
        if(ticket == nil){
            print("ticket nil")
        }else{
            print("ticket not nil")
            ticketName.text = ticket?.name
            ticketName.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            let totePrice:String = String(format:"$ %.1f", ticket!.price)
            totalCost.text = totePrice
            // dictionary example https://developer.apple.com/documentation/swift/dictionary
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            colourBarOne.backgroundColor = colors[ticket!.colour]
            colourBarTwo.backgroundColor = colors[(ticket?.colour)!]
            ticketIdentifier.text = ticket!.colour + " - " + ticket!.iDLetter
            rightID.text = ticket!.iDLetter
            descriptionField.layer.borderWidth = 1.0
            let descolour = UIColor.lightGray.cgColor
            descriptionField.layer.borderColor = descolour
            if ticketData?.margin == 1 {
                winnerField.isUserInteractionEnabled = true
                winnerField.text = "Please Enter Margin Value"
                winnerField.textColor = UIColor.lightGray
            } else {
                winnerField.isUserInteractionEnabled = false
            }
            
        
        descriptionField.text = ticketData!.desc
        ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)
            
            ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldpicker2)
            ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker)
            ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)
    }
    }
    
    func textViewDidBeginEditing(_ textView: UITextField) {
        if textView.textColor == UIColor.lightGray {
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
                ticketPickerSet(targetField: numberToPurchaseField, array: tPicker, targetPicker: pickerView)
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
        let database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabase2")
        
        if(ticketData == nil){
            print("found lost name")
            ticketData = database.selectTicketName(name: nameFromPreviousView!)
        }
        
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd-MM-yyyy "
        let now = df.string(from: Date())
        let num = Int32(numberToPurchaseField.text!)
        let curr = ticketData!.soldTickets
        
    
        for i in stride(from: 1, to: (num! + 1), by: 1) {
            if ticketData?.margin == 0 {
                let emptySpace = Int32(ticketAdd())
            database.insertCustomer(customer:Customer(ticketID: ticketData?.ID ?? -1,
                                                    ticketNum: emptySpace,
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
        
        
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldpicker2)
        ticketTicker(targetField: ticketData!, array: nPicker, targetPicker: soldPicker)
        
        ticketsField.text = String(ticketData!.soldTickets) + "/" + String(ticketData!.maxTickets)
        customerName.text = ""
        customerPhone.text = ""
        customerEmail.text = ""
        numberToPurchaseField.text = String(tPicker[0])
    }
    // I am very proud of this function
    func ticketAdd ()-> Int {
           allTickets = database.selectAllCustomersFromRaffle(id: ticketData!.ID)
            newSet.removeAll()
           for setFill in allTickets {
               newSet.insert(Int(setFill.ticketNum))
           }
           for i in 1 ... Int(ticketData!.maxTickets) {
               print("count: ", i)
               
               if newSet.contains(Int(i)) {
                   print("still looking at: ", i)
               } else {
                   print("found at: ", i)
                    return Int(i)
               }
           }
    
           return 0
       }
    
    // Sets are the best
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
                return
            }))
            
            self.present(alert, animated: true)
        }
        if(!max){
            let alert = UIAlertController(title: "Confirm:", message: "Currently about to sell \(num ?? 0) tickets for \(String(self.totalCost.text ?? "$$"))", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Confirm!", style: .default, handler: { action in
                self.AddCustomerConfirmed()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                return
            }))
            
            self.present(alert, animated: true)
            
        }
        
        
    }
        
    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?)
       {
           if segue.identifier == "TransferToTicketEdit"
           {
                let nextScreen = segue.destination as! SettingsViewController

                nextScreen.idFromPreviousView = idFromPreviousView
               
           }
           
       }
    @IBAction func closeRaffle(_ sender: Any) {
        print("pressedClose")
        
        if(ticketData?.soldTickets == 0 || ableToClose == true){
            let alert = UIAlertController(title: "Warning:", message: "You are about to perminantly delete \(ticketData?.name ?? "the raffle")", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { action in

                self.database.deleteRaffle(id: self.ticketData!.ID)
                
                self.performSegue(withIdentifier: "returnToLibraryPostDeletion", sender: self)
                
                //self.tabBarController!.selectedIndex = 1
                
                return
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                return
            }))
            
            self.present(alert, animated: true)
        }else{
            let alert = UIAlertController(title: "Warning:", message: "Cannot delete \(ticketData?.name ?? "the raffle") until a winner has been drawn", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                return
            }))
            
            self.present(alert, animated: true)
        }
    }
    func contactWinner(ticket:Ticket, winner:Customer){
        if(ticket.margin == 1){
            print("contact winner margin")
            let shareText = "The results are in! The winner of the \"\(ticket.name)\" margin raffle is *drum roll* \"\(winner.name)\" with a ticket number of \(winner.ticketNum)!"
            if let image = Data(base64Encoded: ticketData!.image){ //has image
                let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
                present(vc, animated:true)
            }else{
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                present(vc, animated:true)
            }
        }else{
            print("contact winner classic")
            let shareText = "The results are in! The winner of the \"\(ticket.name)\" raffle is *drum roll* \"\(winner.name)\" with a ticket number of \(winner.ticketNum)!"
            if let image = Data(base64Encoded: ticketData!.image){ 
                let vc = UIActivityViewController(activityItems: [shareText, image], applicationActivities: [])
                present(vc, animated:true)
            }else{
                let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
                present(vc, animated:true)
            }
        }
    }

}
