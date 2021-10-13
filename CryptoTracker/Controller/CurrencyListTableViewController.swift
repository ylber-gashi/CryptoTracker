import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
}

class CurrencyListTableViewController: UITableViewController {

    var currencies: [Currency] = [];
    var db: DBHelper = DBHelper()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Ckemi")
        
        self.getCoinListRequest();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Knej: " + currencies.count.description)
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyItem", for: indexPath) as! CurrencyTableViewCell

        // Configure the cell...
        
        let currency: Currency = currencies[indexPath.row];

        cell.name?.text = currency.name
        cell.price?.text = currency.price_usd?.description
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        print("Clicked!")
//
//        let controller = DetailViewController(currency: self.currencies[indexPath.row])
//
//        self.navigationController?.pushViewController(controller, animated: true)
//    }
    
    
    // MARK: Async Task
    
    func getCoinListRequest() -> Int {
        let url = URL(string: "https://rest.coinapi.io/v1/assets")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("78725B98-B33B-4210-A9A9-5C557D50D80C", forHTTPHeaderField: "X-CoinAPI-Key")
        
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            
            
            
            if let error = error {
                print("Gabim!")
                return;
            }
            
            // Read HTTP Response Status code
               if let response = response as? HTTPURLResponse {
                   print("Response HTTP Status code: \(response.statusCode)")
               }
               
               // Convert HTTP Response Data to a simple String
               if let data = data {
                   //     print("Response data string:\n \(dataString)")
                
                
                let decoder = JSONDecoder()

                do {
                    let currencies = try decoder.decode([Currency].self, from: data)
                    
//                    self.currencies = currencies.filter {
//                        currency in
//
//
//
//                        return currency.price_usd != nil && currency.type_is_crypto == 1
//                    };
                    
                    for currency in currencies {
                        
                        if(currency.price_usd != nil && currency.type_is_crypto == 1 && currency.name != nil && currency.asset_id != nil){
                            self.db.insert(name: currency.name!, asset_id: currency.asset_id!, type_is_crypto: currency.type_is_crypto!, price_usd: currency.price_usd!)
                        }
                        
                    }
                    
                    self.currencies = self.db.read();
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
               }
            
        }
        

        task.resume()
        return 0
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if segue.identifier == "showDetailView" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! DetailViewController
                controller.currency = currencies[indexPath.row]
            }
        }
    }


}
