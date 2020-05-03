//
//  Customer.swift
//  Tutorial5
//
//  Created by Liam kenna on 3/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import Foundation

public struct Customer{
    var ID:Int32 = -1
    var ticketID:Int32
    var ticketNum:Int32 //which ticket number they bought
    var purchaseTime:String
    var refunded:Int32 //boolean
    
    var name:String
    var phone:Int32
    var email:String    
}
