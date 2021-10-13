import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    var currency: Currency?
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
    
    @IBOutlet weak var total: UITextField!
    
    
    @IBAction func onQuantityChanged(_ sender: UITextField) {
        
        print(sender.text?.description)
        let quantity = Float(sender.text?.description ?? "" );
        
        if(quantity != nil){
            let total: Float = quantity! * (self.currency?.price_usd)!
            
            self.total.text = total.description
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please enter only numbers!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    //    init(currency: Currency) {
//        self.currency = currency;
//        super.init(nibName: nil, bundle: nil)
//
//        print("Bravo per neve!!!!!")
//
//    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        
//    }
    
    override func viewDidLoad() {
        self.name.text = self.currency?.name
        self.price.text = self.currency?.price_usd?.description
        
        self.quantity.text = "1"
        self.total.text = self.currency?.price_usd?.description
        
        
        self.quantity.delegate = self
        
    }
    
    
    func textViewDidChange(_ textView: UITextView) { //Handle the text changes here
        print(textView.text); //the textView parameter is the textView where text was changed
    }
    
}
