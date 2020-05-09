//
//  SettingsViewController.swift
//  Tutorial5
//
//  Created by Fiona Colbert on 25/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var ticketTitle: UILabel!
    var nameFromPreviousView: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticketTitle.text = nameFromPreviousView!
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
