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


    var tickets = [Ticket]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")
        /*
        database.insertTicket(ticket:Ticket(open:1, name:"Debug Joe's Big BBQ", desc:"Wow ! its time for a big BBQ with Debug Joe yeehaw YEEEHAW",margin:0,price:1.99,iDLetter:"B",colour:"green"))
            
        database.insertTicket(ticket:Ticket(open:1, name:"Debug Moe's Bigger BBQ", desc:"COME TO THE BIGGEST BBQ YET (WAY COOLER THAN JOES BBQ)",margin:1,price:4.99,iDLetter:"A",colour:"green"))
        */
        tickets = database.selectAllTickets()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let  database : SQLiteDatabase = SQLiteDatabase(databaseName: "MyDatabase")

        tickets = database.selectAllTickets()
        
        self.collectionView.reloadData()
        print("wowowow")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketUICollectionViewCell", for: indexPath)
    
        // Configure the cell
        let ticket = tickets[indexPath.row]
        if let  ticketCell = cell as? TicketUICollectionViewCell
        {
            ticketCell.name.text = ticket.name

            
            ticketCell.price.text = "$" + String(ticket.price)
            //ticketCell.button.ticket = ticket
            //ticketCell.button.setTitle((title: "help", String(ticket.ID))
            
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    /*@IBAction func SegueToSell() {
        /*let vc = SecondViewController(nibName: "SecondViewController", bundle: nil)
            //vc.text = "Next level blog photo booth, tousled authentic tote bag kogi"

            navigationController?.pushViewController(vc, animated: true)*/
        
    }*/
    @IBAction func segueToSell(_ sender: UIButton) {
        print("pressed")
        //self.performSegue(withIdentifier: "TransferTicketToSell", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepared")
        
        if(segue.identifier == "TransferTicketToSell"){
            
            //let displayVC = segue.destination as! SecondViewController
            //displayVC.ticketID = 1
            guard let detailViewController = segue.destination as? SecondViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedTicketCell = sender as? TicketUICollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing:sender))")
            }
            
            guard let indexPath = collectionView.indexPath(for:selectedTicketCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            //var indexPath = collectionView.indexPath(for:selectedTicketCell)
            print("post prep")
            let selectedTicket = tickets[indexPath.row]
            let nextScreen = segue.destination as! SecondViewController
            nextScreen.nameFromPreviousView = selectedTicket.name
            print(selectedTicket.name + " is abotu to be transfered")
            detailViewController.ticket = selectedTicket
            
            //let selectedMovie = tickets[indexPath.row]
            //detailViewController.movie = selectedMovie
             
        }
    }
}
