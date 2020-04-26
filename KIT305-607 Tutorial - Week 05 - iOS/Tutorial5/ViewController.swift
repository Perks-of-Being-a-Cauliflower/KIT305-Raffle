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


    
    @IBAction func showInputMenu(_ sender: UITextField) {
        var temp: String? = chosenNameField.text
        confirmedName.text = temp
        chosenNameField.isUserInteractionEnabled = false
        confirmedName.isUserInteractionEnabled = true
        confirmedName.becomeFirstResponder()
        popUpView.isHidden = false
        print("STOP YOU VIOLATED THE LAW!")
    }
    
    @IBAction func confirmButton(_ sender: UIButton) {
        //chosenNameField.resignFirstResponder()
        //self.view.endEditing(true)
        confirmedName.isUserInteractionEnabled = false
        var newName: String? = confirmedName.text
        chosenNameField.text = newName
        popUpView.isHidden = true
        chosenNameField.isUserInteractionEnabled = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        confirmedName.isUserInteractionEnabled = false
        popUpView.isHidden = true
        chosenNameField.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //popUpView.isHidden = true
        chosenNameField.allowsEditingTextAttributes = false
        //confirmedName.becomeFirstResponder()
        //chosenNameField.isUserInteractionEnabled = false
    }
    


}

