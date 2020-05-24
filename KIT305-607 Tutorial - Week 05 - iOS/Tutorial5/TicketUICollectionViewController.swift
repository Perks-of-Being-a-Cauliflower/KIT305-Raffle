//
//  TicketUICollectionViewController.swift
//  Tutorial5
//
//  Created by Liam kenna on 2/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class TicketUICollectionViewController: UICollectionViewController {


    @IBOutlet var emptyLibraryWindow: UIView!
    
    var tickets = [Ticket]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")

        tickets = database.selectAllTickets()
        if(tickets.count <= 0){
            emptyLibraryWindow.isHidden = false
        }else{
            emptyLibraryWindow.isHidden = true
        }
        self.navigationItem.setHidesBackButton(true, animated: true);
    }
    override func viewWillAppear(_ animated: Bool) {
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")

        tickets = database.selectAllTickets()
        
        self.collectionView.reloadData()

        if(tickets.count <= 0){
            emptyLibraryWindow.isHidden = false
        }else{
            emptyLibraryWindow.isHidden = true
        }
        self.navigationItem.setHidesBackButton(true, animated: true);
    }

    @IBAction func moveToCreateRaffle(_ sender: Any) {
        self.tabBarController!.selectedIndex = 0
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return tickets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketUICollectionViewCell", for: indexPath)
    
        // Configure the cell
        let ticket = tickets[(tickets.count-1) - indexPath.row]
        if let  ticketCell = cell as? TicketUICollectionViewCell
        {
            ticketCell.name.text = ticket.name

            
            ticketCell.price.text = "$" + String(ticket.price)
            
            let newString: String? = String(ticket.soldTickets)
            let intCompare: Int = Int(ticket.soldTickets)
            
            if intCompare == 0 {
                ticketCell.ticketCounter.text = "000"
            } else if intCompare <= 9 {
                ticketCell.ticketCounter.text = "00" + newString!
            } else if intCompare >= 10 && intCompare <= 99 {
                ticketCell.ticketCounter.text = "0" + newString!
                } else {
                ticketCell.ticketCounter.text = newString!
            }
            
            let colors : [String:UIColor] = ["White": UIColor.white, "Orange":
            UIColor.orange, "Blue": UIColor.blue,"Green":
            UIColor.green,"Red": UIColor.red,"Yellow":UIColor.yellow,"Brown": UIColor.brown,
            "Pink": UIColor.systemPink]
            
            ticketCell.topColour.backgroundColor = colors[ticket.colour]
            ticketCell.bottomColour.backgroundColor = colors[ticket.colour]
            
            if(ticket.image != "na"){
                ticketCell.imageField.isHidden = false
                let newImageData = Data(base64Encoded: ticket.image)
                //print("new data is: ", newImageData)
                if let newImageData = newImageData {
                   ticketCell.imageField.image = UIImage(data: newImageData)
                }                
            }else{
                print("ticket na")
                ticketCell.imageField.isHidden = true
            }
            //print("id is: ", ticket.ID)
            
            ticketCell.iDLetter.text = ticket.iDLetter
            
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    @IBAction func segueToSell(_ sender: UIButton) {
        print("pressed")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepared")
        
        if(segue.identifier == "TransferTicketToSell"){

            guard let detailViewController = segue.destination as? SecondViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTicketCell = sender as? TicketUICollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing:sender))")
            }
            
            guard let indexPath = collectionView.indexPath(for:selectedTicketCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            print("post prep")
            let selectedTicket = tickets[(tickets.count-1) - indexPath.row]
            let nextScreen = segue.destination as! SecondViewController
            nextScreen.idFromPreviousView = selectedTicket.ID
            print(selectedTicket.name + " is abotu to be transfered")
            detailViewController.ticketData = selectedTicket             
        }
    }
}
