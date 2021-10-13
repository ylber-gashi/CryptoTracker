import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "cryptoTracker.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS currencies(name TEXT,asset_id TEXT, type_is_crypto INTEGER, price_usd DOUBLE);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("currencies table created.")
            } else {
                print("currencies table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(name:String, asset_id: String, type_is_crypto: Int,  price_usd:Float)
    {
       
        let insertStatementString = "INSERT INTO currencies (name, asset_id, type_is_crypto, price_usd) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (asset_id as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(type_is_crypto))
            sqlite3_bind_double(insertStatement, 4, Double(price_usd))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Currency] {
        let queryStatementString = "SELECT * FROM currencies;"
        var queryStatement: OpaquePointer? = nil
        var currencies : [Currency] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let asset_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let type_is_crypto = sqlite3_column_int(queryStatement, 2)
                let price_usd = sqlite3_column_double(queryStatement, 3)
                
                currencies.append(Currency(asset_id: asset_id, name: name, type_is_crypto: Int(type_is_crypto), price_usd: Float(price_usd)))
                print("Query Result:")
                print("\(name) | \(asset_id) | \(price_usd)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return currencies
    }
    
    func deleteAll(id:Int) {
        let deleteStatementStirng = "DELETE * FROM currencies;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {             if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
