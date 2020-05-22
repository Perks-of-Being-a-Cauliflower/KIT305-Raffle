//
//  SQLiteDatabase.swift
//  Tutorial5
//
//  Created by Lindsay Wells (updated 2020).
//
//  You are welcome to use this class in your assignments, but you will need to modify it in order for
//  it to do anything!
//
//  Add your code to the end of this class for handling individual tables
//
//  Known issues: doesn't handle versioning and changing of table structure.
//

import Foundation
import SQLite3

class SQLiteDatabase
{
    /* This variable is of type OpaquePointer, which is effectively the same as a C pointer (recall the SQLite API is a C-library). The variable is declared as an optional, since it is possible that a database connection is not made successfully, and will be nil until such time as we create the connection.*/
    private var db: OpaquePointer?
    
    /* Change this value whenever you make a change to table structure.
        When a version change is detected, the updateDatabase() function is called,
        which in turn calls the createTables() function.
     
        WARNING: DOING THIS WILL WIPE YOUR DATA, unless you modify how updateDatabase() works.
     */
    private let DATABASE_VERSION = 24
    
    
    
    // Constructor, Initializes a new connection to the database
    /* This code checks for the existence of a file within the application’s document directory with the name <dbName>.sqlite. If the file doesn’t exist, it attempts to create it for us. Since our application has the ability to write into this directory, this should happen the first time that we run the application without fail (it can still possibly fail if the device is out of storage space).
     The remainder of the function checks to see if we are able to open a successful connection to this database file using the sqlite3_open() function. With all of the SQLite functions we will be using, we can check for success by checking for a return value of SQLITE_OK.
     */
    init(databaseName dbName:String)
    {
        //get a file handle somewhere on this device
        //(if it doesn't exist, this should create the file for us)
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(dbName).sqlite")
        
        //try and open the file path as a database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK
        {
            print("Successfully opened connection to database at \(fileURL.path)")
            self.dbName = dbName
            checkForUpgrade();
        }
        else
        {
            print("Unable to open database at \(fileURL.path)")
            printCurrentSQLErrorMessage(db)
        }
        
    }
    
    deinit
    {
        /* We should clean up our memory usage whenever the object is deinitialized, */
        sqlite3_close(db)
    }
    private func printCurrentSQLErrorMessage(_ db: OpaquePointer?)
    {
        let errorMessage = String.init(cString: sqlite3_errmsg(db))
        print("Error:\(errorMessage)")
    }
    
    private func createTables()
    {
        //INSERT YOUR createTable function calls here
        //e.g. createMovieTable()
        createTicketTable()
        createCustomerTable()
    }
    private func dropTables()
    {
        //INSERT YOUR dropTable function calls here
        dropTable(tableName:"Ticket")
        dropTable(tableName:"Customer")
        //e.g. dropTable(tableName:"Movie")
    }
    
    /* --------------------------------*/
    /* ----- VERSIONING FUNCTIONS -----*/
    /* --------------------------------*/
    private var dbName:String = ""
    func checkForUpgrade()
    {
        // get the current version number
        let defaults = UserDefaults.standard
        let lastSavedVersion = defaults.integer(forKey: "DATABASE_VERSION_\(dbName)")
        
        // detect a version change
        if (DATABASE_VERSION > lastSavedVersion)
        {
            onUpdateDatabase(previousVersion:lastSavedVersion, newVersion: DATABASE_VERSION);
            
            // set the stored version number
            defaults.set(DATABASE_VERSION, forKey: "DATABASE_VERSION_\(dbName)")
        }
    }
    
    func onUpdateDatabase(previousVersion : Int, newVersion : Int)
    {
        print("Detected Database Version Change (was:\(previousVersion), now:\(newVersion))")
        
        //handle the change (simple version)
        dropTables()
        createTables()
    }
    
    
    
    /* --------------------------------*/
    /* ------- HELPER FUNCTIONS -------*/
    /* --------------------------------*/
    
    /* Pass this function a CREATE sql string, and a table name, and it will create a table
        You should call this function from createTables()
     */
    private func createTableWithQuery(_ createTableQuery:String, tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        //prepare the statement
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK
        {
            //execute the statement
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("\(tableName) table created.")
            }
            else
            {
                print("\(tableName) table could not be created.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("CREATE TABLE statement for \(tableName) could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clean up
        sqlite3_finalize(createTableStatement)
        
    }
    /* Pass this function a table name.
        You should call this function from dropTables()
     */
    private func dropTable(tableName:String)
    {
        /*
         1.    sqlite3_prepare_v2()
         2.    sqlite3_step()
         3.    sqlite3_finalize()
         */
        
        //prepare the statement
        let query = "DROP TABLE IF EXISTS \(tableName)"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, query, -1, &statement, nil)     == SQLITE_OK
        {
            //run the query
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(tableName) table deleted.")
            }
        }
        else
        {
            print("\(tableName) table could not be deleted.")
            printCurrentSQLErrorMessage(db)
        }
        
        //clear up
        sqlite3_finalize(statement)
    }
    
    //helper function for handling INSERT statements
    //provide it with a binding function for replacing the ?'s for setting values
    private func insertWithQuery(_ insertStatementQuery : String, bindingFunction:(_ insertStatement: OpaquePointer?)->())
    {
        /*
         Similar to the CREATE statement, the INSERT statement needs the following SQLite functions to be called (note the addition of the binding function calls):
         1.    sqlite3_prepare_v2()
         2.    sqlite3_bind_***()
         3.    sqlite3_step()
         4.    sqlite3_finalize()
         */
        // First, we prepare the statement, and check that this was successful. The result will be a C-
        // pointer to the statement:
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementQuery, -1, &insertStatement, nil) == SQLITE_OK
        {
            //handle bindings
            bindingFunction(insertStatement)
            
            /* Using the pointer to the statement, we can call the sqlite3_step() function. Again, we only
             step once. We check that this was successful */
            //execute the statement
            if sqlite3_step(insertStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
            }
            else
            {
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("INSERT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
    
        //clean up
        sqlite3_finalize(insertStatement)
    }
    
    //helper function to run Select statements
    //provide it with a function to do *something* with each returned row
    //(optionally) Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func selectWithQuery(
        _ selectStatementQuery : String,
        eachRow: (_ rowHandle: OpaquePointer?)->(),
        bindingFunction: ((_ rowHandle: OpaquePointer?)->())? = nil)
    {
        //prepare the statement
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementQuery, -1, &selectStatement, nil) == SQLITE_OK
        {
            //do bindings, only if we have a bindingFunction set
            //hint, to do selectMovieBy(id:) you will need to set a bindingFunction (if you don't hardcode the id)
            bindingFunction?(selectStatement)
            
            //iterate over the result
            while sqlite3_step(selectStatement) == SQLITE_ROW
            {
                eachRow(selectStatement);
            }
            
        }
        else
        {
            print("SELECT statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(selectStatement)
    }
    //LIAMS IN PROGRESS BIT
    private func deleteWithQuery(
        _ deleteStatementQuery : String,
        bindingFunction: ((_ rowHandle: OpaquePointer?)->()))
    {
        //prepare the statement
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementQuery, -1, &deleteStatement, nil) == SQLITE_OK
        {
            //do bindings
            bindingFunction(deleteStatement)
            
            //execute
            if sqlite3_step(deleteStatement) == SQLITE_DONE
            {
                print("Successfully deleted row.")
            }
            else
            {
                print("Could not delete row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("DELETE statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(deleteStatement)
    }
    
    //helper function to run update statements.
    //Provide it with a binding function for replacing the "?"'s in the WHERE clause
    private func updateWithQuery(
        _ updateStatementQuery : String,
        bindingFunction: ((_ rowHandle: OpaquePointer?)->()))
    {
        //prepare the statement
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementQuery, -1, &updateStatement, nil) == SQLITE_OK
        {
            //do bindings
            bindingFunction(updateStatement)
            
            //execute
            if sqlite3_step(updateStatement) == SQLITE_DONE
            {
                print("Successfully inserted row.")
            }
            else
            {
                print("Could not insert row.")
                printCurrentSQLErrorMessage(db)
            }
        }
        else
        {
            print("UPDATE statement could not be prepared.")
            printCurrentSQLErrorMessage(db)
        }
        //clean up
        sqlite3_finalize(updateStatement)
    }
    
    /* --------------------------------*/
    /* --- ADD YOUR TABLES ETC HERE ---*/
    /* --------------------------------*/
    
    //SQLite does not have boolean, if margin = 1 = true, ELSE margin = 0 = false 
        //int to represent which color, since we control the swatches
        //still need to figure out storing customers and end conditions.
            //could do customers in a list and have them reference the ID of the ticket, idk.
        //also need to store how many tickets have been sold / how many remain.
        //could probably store char as a single letter, but unsure tbh
    func createTicketTable() {
        let createTicketTableQuery = """
        CREATE TABLE Ticket (
            ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            Open INTEGER,
            Name CHAR(255),
            Desc CHAR(255),
            Margin INTEGER,
            Price DOUBLE,
            IDLetter CHAR(255),
            Colour CHAR(255),
            MaxTickets INTEGER,
            SoldTickets INTEGER,
            Image TEXT
        );
        """
        createTableWithQuery(createTicketTableQuery, tableName: "Ticket")
    }
    
    func createCustomerTable() {
        let createCustomerTableQuery = """
        CREATE TABLE Customer (
            ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            TicketID INTEGER,
            TicketNum INTEGER,
            PurchaseTime CHAR(255),
            Refunded INTEGER,
            Name CHAR(255),
            Phone INTEGER,
            Email CHAR(255)
        );
        """
        createTableWithQuery(createCustomerTableQuery, tableName: "Customer")
    }
    
    func insertTicket(ticket:Ticket) {
        let insertStatementQuery = "INSERT INTO Ticket (Open, Name, Desc, Margin, Price, IDLetter, Colour, MaxTickets, SoldTickets, Image) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_int(insertStatement, 1, ticket.open)
            sqlite3_bind_text(insertStatement, 2, NSString(string:ticket.name).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, NSString(string:ticket.desc).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, ticket.margin)
            sqlite3_bind_double(insertStatement, 5, ticket.price)
            sqlite3_bind_text(insertStatement, 6, NSString(string:ticket.iDLetter).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, NSString(string:ticket.colour).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 8, ticket.maxTickets)
            sqlite3_bind_int(insertStatement, 9, ticket.soldTickets)
            sqlite3_bind_text(insertStatement, 10, NSString(string:ticket.image).utf8String, -1, nil)
        })
    }
    
    func insertCustomer(customer:Customer) {
        let insertStatementQuery = "INSERT INTO Customer (TicketID, TicketNum, PurchaseTime, Refunded, Name, Phone, Email) VALUES (?, ?, ?, ?, ?, ?, ?);"
        
        insertWithQuery(insertStatementQuery, bindingFunction: { (insertStatement) in
            sqlite3_bind_int(insertStatement, 1, customer.ticketID)
            sqlite3_bind_int(insertStatement, 2, customer.ticketNum)
            sqlite3_bind_text(insertStatement, 3, NSString(string:customer.purchaseTime).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 4, customer.refunded)
            sqlite3_bind_text(insertStatement, 5, NSString(string:customer.name).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, customer.phone)
            sqlite3_bind_text(insertStatement, 7, NSString(string:customer.email).utf8String, -1, nil)
        })
    }
    
    func selectAllTickets() -> [Ticket]
    {
        var result = [Ticket]()
        let selectStatementQuery = "SELECT id, open, name, desc, margin, price, iDLetter, colour, maxTickets, soldTickets, image FROM Ticket"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            //create a movie object from each result
            let ticket = Ticket(ID: sqlite3_column_int(row, 0),
                                open: sqlite3_column_int(row, 1),
                                name: String(cString:sqlite3_column_text(row, 2)),
                                desc: String(cString:sqlite3_column_text(row, 3)),
                                margin: sqlite3_column_int(row, 4),
                                price: sqlite3_column_double(row, 5),
                                iDLetter: String(cString:sqlite3_column_text(row, 6)),
                                colour: String(cString:sqlite3_column_text(row, 7)),
                                maxTickets: sqlite3_column_int(row, 8),
                                soldTickets: sqlite3_column_int(row, 9),
                                image: String(cString:sqlite3_column_text(row, 10))
            )
            //add it to the result array
            result += [ticket]
            
        })
        return result
    }
    
    func selectAllCustomers() -> [Customer]
    {
        var result = [Customer]()
        let selectStatementQuery = "SELECT id, ticketID, ticketNum, purchaseTime, refunded, name, phone, email FROM Customer"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            //create a movie object from each result
            let customer = Customer(ID: sqlite3_column_int(row, 0),
                                    ticketID: sqlite3_column_int(row, 1),
                                    ticketNum: sqlite3_column_int(row, 2),
                                    purchaseTime: String(cString:sqlite3_column_text(row, 3)),
                                    refunded: sqlite3_column_int(row, 4),
                                    name: String(cString:sqlite3_column_text(row, 5)),
                                    phone: sqlite3_column_int(row, 6),
                                    email: String(cString:sqlite3_column_text(row, 7))
            )
            //add it to the result array
            result += [customer]
            
        })
        return result
    }
    
    func selectAllCustomersFromRaffle(id:Int32) -> [Customer]
    {
        var result = [Customer]()
        let selectStatementQuery = "SELECT id, ticketID, ticketNum, purchaseTime, refunded, name, phone, email FROM Customer"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
            //create a movie object from each result
            let customer = Customer(ID: sqlite3_column_int(row, 0),
                                    ticketID: sqlite3_column_int(row, 1),
                                    ticketNum: sqlite3_column_int(row, 2),
                                    purchaseTime: String(cString:sqlite3_column_text(row, 3)),
                                    refunded: sqlite3_column_int(row, 4),
                                    name: String(cString:sqlite3_column_text(row, 5)),
                                    phone: sqlite3_column_int(row, 6),
                                    email: String(cString:sqlite3_column_text(row, 7))
            )
            //add it to the result array
            if(customer.ticketID == id){
                //print("even steven")
                result += [customer]
            }else{
                //print(String(customer.ticketID) + " is different from " + String(id))
            }
            
            
        })
        return result
    }
    
    func selectTicketBy(id:Int32) -> Ticket?
    {
        var result : Ticket?
        
        var potential = [Ticket]()
        let selectStatementQuery = "SELECT id, open, name, desc, margin, price, iDLetter, colour, maxTickets, soldTickets, image FROM Ticket"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
        
            let ticket = Ticket(
            ID: sqlite3_column_int(row, 0),
            open: sqlite3_column_int(row, 1),
            name: String(cString:sqlite3_column_text(row, 2)),
            desc: String(cString:sqlite3_column_text(row, 3)),
            margin: sqlite3_column_int(row, 4),
            price: sqlite3_column_double(row, 5),
            iDLetter: String(cString:sqlite3_column_text(row, 6)),
            colour: String(cString:sqlite3_column_text(row, 7)),
            maxTickets: sqlite3_column_int(row, 8),
            soldTickets: sqlite3_column_int(row, 9),
            image: String(cString:sqlite3_column_text(row, 10))
        )
        potential += [ticket]
        })
        
        for t in potential {
            if(t.ID == id){
                result = t
                return t
            }
        }
        
        
        
        return result
    }
    
    func selectTicketName(name:String) -> Ticket?
    {
        var result : Ticket?
        
        var potential = [Ticket]()
        let selectStatementQuery = "SELECT id, open, name, desc, margin, price, iDLetter, colour, maxTickets, soldTickets, image FROM Ticket"
        
        selectWithQuery(selectStatementQuery, eachRow: { (row) in
        
            let ticket = Ticket(
            ID: sqlite3_column_int(row, 0),
            open: sqlite3_column_int(row, 1),
            name: String(cString:sqlite3_column_text(row, 2)),
            desc: String(cString:sqlite3_column_text(row, 3)),
            margin: sqlite3_column_int(row, 4),
            price: sqlite3_column_double(row, 5),
            iDLetter: String(cString:sqlite3_column_text(row, 6)),
            colour: String(cString:sqlite3_column_text(row, 7)),
            maxTickets: sqlite3_column_int(row, 8),
            soldTickets: sqlite3_column_int(row, 9),
            image: String(cString:sqlite3_column_text(row, 10))
        )
        potential += [ticket]
        })
        
        for t in potential {
            //print("the name is: ", t.name)
            //print("check against: ", name)
            //print("t is equal to: ", t)
            if(t.name == name){
                result = t
                return t
            }
        }
        
        
        return result
    }
    
    
    
    func updateSoldTickets(ticketID:Int32, newNum:Int32){
        
        print("update ticket sold " + String(newNum))
        //let updateStatementQuery = "SELECT id, open, name, desc, margin, price, iDLetter, colour, maxTickets, soldTickets FROM Ticket"
        let updateStatementQuery = "UPDATE Ticket SET soldTickets = ? WHERE id = ?;"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in                            
                            sqlite3_bind_int(updateStatement, 1, newNum)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                        })
                        
    }
    
    func updateMaxTickets(ticketID:Int32, newNum:Int32){
        
        print("update ticket max tick " + String(newNum))
        //let updateStatementQuery = "SELECT id, open, name, desc, margin, price, iDLetter, colour, maxTickets, soldTickets FROM Ticket"
        let updateStatementQuery = "UPDATE Ticket SET MaxTickets = ? WHERE id = ?;"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in
                            sqlite3_bind_int(updateStatement, 1, newNum)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                        })
                        
    }
    
    func updateTicketName(ticketID:Int32, newString:String){
        //check for other tickets with name.
        
        
        print("update name " + String(newString))
        
        let updateStatementQuery = "UPDATE Ticket SET Name = ? WHERE ID = ?;"
        //let newUpdateStatement = "UPDATE .... SET Name = ? .... WHERE ID = ?"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in
                            sqlite3_bind_text(updateStatement, 1, newString, -1, nil)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                            
        })
    }
    
    func updateTicketImage(ticketID:Int32, newString:String){
        //check for other tickets with name.
        
        //print("id is " + String(ticketID))
        print("update ticket image " + String(newString))
        
        let updateStatementQuery = "UPDATE Ticket SET Image = ? WHERE ID = ?;"
        //let newUpdateStatement = "UPDATE .... SET Name = ? .... WHERE ID = ?"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in
                            sqlite3_bind_text(updateStatement, 1, newString, -1, nil)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                            
        })
    }
        
     func updateTicketDesc(ticketID:Int32, newString:String){
        print("update ticket desc " + String(newString))
        let updateStatementQuery = "UPDATE Ticket SET Desc = ? WHERE ID = ?;"
        //let newUpdateStatement = "UPDATE .... SET Name = ? .... WHERE ID = ?"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in
                            sqlite3_bind_text(updateStatement, 1, newString, -1, nil)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                            
        })
    }
        
    func updateTicketColour(ticketID:Int32, newString:String){
        
        print("update ticket colour " + String(newString))
    let updateStatementQuery = "UPDATE Ticket SET Colour = ? WHERE ID = ?;"
    //let newUpdateStatement = "UPDATE .... SET Name = ? .... WHERE ID = ?"
    updateWithQuery(updateStatementQuery,
                    bindingFunction: { (updateStatement) in
                        sqlite3_bind_text(updateStatement, 1, newString, -1, nil)
                        sqlite3_bind_int(updateStatement, 2, ticketID)
                        
    })
    }
        
    func updateTicketInfo(ticket:Ticket){
        
        print("update ticket not called ")
        //let updateStatementQuery = "UPDATE Ticket SET soldTickets = " + String(newNum) + " WHERE id = " + String(ticketID) + ";"
        
        //let updateStatementQuery = "UPDATE Ticket SET open = " + ticket.open + ", name = " + ticket.name + ", desc = " + ticket.desc + ", margin = " + ticket.margin + ", price = " + ticket.price + ", iDLetter = " + ticket.iDLetter + ", colour = " + ticket.colour + ", maxTickets = " + ticket.maxTickets + ", soldTickets = " + ticket.soldTickets + " WHERE id = " + ticket.ID + ";"
        
        //let updateStatementQuery = "UPDATE Ticket SET open = " + ticket.open + ", name = " + ticket.name + ", desc = " + ticket.desc + ", margin = " + ticket.margin + ", price = " + ticket.price + ", iDLetter = " + ticket.iDLetter + ", colour = " + ticket.colour + ", maxTickets = " + ticket.maxTickets + " WHERE id = " + ticket.ID + ";"
        
        /*let updateStatementQuery = "UPDATE Ticket SET open = " + ticket.open + ", name = " + ticket.name + ", desc = " + ticket.desc
            
            updateStatementQuery += ", margin = " + ticket.margin + ", price = " + ticket.price + ", iDLetter = " + ticket.iDLetter
        
            updateStatementQuery += ", colour = " + ticket.colour + ", maxTickets = " + ticket.maxTickets + ", soldTickets = " + ticket.soldTickets + " WHERE id = " + ticket.ID + ";"
        */
        
        let updateStatementQuery = "UPDATE Ticket SET open = \(ticket.open), name = '\(ticket.name)', desc = '\(ticket.desc)', margin = \(ticket.margin), price = \(ticket.price), iDLetter = '\(ticket.iDLetter)', colour = '\(ticket.colour)', maxTickets = \(ticket.maxTickets) WHERE id = \(ticket.ID);"
        
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in   //eachRow: { (row) in
                            sqlite3_bind_int(updateStatement, 1, ticket.open)
                            sqlite3_bind_text(updateStatement, 2, NSString(string:ticket.name).utf8String, -1, nil)
                            sqlite3_bind_text(updateStatement, 3, NSString(string:ticket.desc).utf8String, -1, nil)
                            sqlite3_bind_int(updateStatement, 4, ticket.margin)
                            sqlite3_bind_double(updateStatement, 5, ticket.price)
                            sqlite3_bind_text(updateStatement, 6, NSString(string:ticket.iDLetter).utf8String, -1, nil)
                            sqlite3_bind_text(updateStatement, 7, NSString(string:ticket.colour).utf8String, -1, nil)
                            sqlite3_bind_int(updateStatement, 8, ticket.maxTickets)
                            //sqlite3_bind_int(updateStatement, 9, ticket.soldTickets)
                        })
    }
    
    func deleteCustomer(id:Int32)
    {
        //var result = [Customer]()
        print("p1 " + String(id))
        let deleteStatementQuery = "DELETE FROM Customer WHERE id = ?;"
        
        deleteWithQuery(deleteStatementQuery,
                        bindingFunction: { (deleteStatement) in   //eachRow: { (row) in
                            sqlite3_bind_int(deleteStatement, 1, id)
                        })
        print("p2")
        
    }
    
    func updateCustomerTicketNumber(ticketID:Int32, ticketNumber:Int32){
        //SELECT id, ticketID, ticketNum, purchaseTime, refunded, name, phone, email FROM Customer"
        let updateStatementQuery = "UPDATE Customer SET ticketNum = ? WHERE id = ?;"
        //let newUpdateStatement = "UPDATE .... SET Name = ? .... WHERE ID = ?"
        updateWithQuery(updateStatementQuery,
                        bindingFunction: { (updateStatement) in
                            sqlite3_bind_int(updateStatement, 1, ticketNumber)
                            sqlite3_bind_int(updateStatement, 2, ticketID)
                            
        })
    }
    
}
