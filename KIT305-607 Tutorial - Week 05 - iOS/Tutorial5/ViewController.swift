//
//  ViewController.swift
//  Tutorial5
//
//  Created by Lindsay Wells.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate
{
    
    // a handle to the database itself
    // you can switch databases or create new blank ones by changing databaseName
    var database : SQLiteDatabase = SQLiteDatabase(databaseName:"MyDatabasesdfg")
    
    
    @IBOutlet weak var confirmedName: UITextField!
    
    @IBOutlet weak var chosenNameField: UITextField!
    @IBOutlet weak var popUpView: UIView!

    @IBAction func openInputBox(_ sender: UITextField) {
        
        popUpView.isHidden = false
    }
    
    
    @IBAction func confirmButton(_ sender: UIButton) {
        //chosenNameField.resignFirstResponder()
        //self.view.endEditing(true)
        var newName: String? = confirmedName.text
        chosenNameField.text = newName
        popUpView.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        print("Delicious Biscuits")
        popUpView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.isHidden = true
        //chosenNameField.allowsEditingTextAttributes = false
        //confirmedName.becomeFirstResponder()
        chosenNameField.isUserInteractionEnabled = false
    }
    


}

