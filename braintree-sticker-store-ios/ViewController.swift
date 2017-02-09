import UIKit
import Alamofire
import BraintreeDropIn
import Braintree

class ViewController: UIViewController {
    
    let checkoutStackView = UIStackView()
    let payButton = UIButton(type: .roundedRect)
    var paymentMethod : BTPaymentMethodNonce?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Checkout"
        
        self.view.addSubview(self.checkoutStackView)
        checkoutStackView.translatesAutoresizingMaskIntoConstraints = false
        checkoutStackView.axis  = .vertical
        checkoutStackView.spacing = 20
        checkoutStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        checkoutStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        checkoutStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        let itemDetailsStackView = UIStackView()
        checkoutStackView.addArrangedSubview(itemDetailsStackView)
        itemDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        itemDetailsStackView.axis  = .horizontal
        itemDetailsStackView.spacing = 20
        
        let itemImage = UIImageView(image: UIImage(named: "rocket-sticker"))
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        itemImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemDetailsStackView.addArrangedSubview(itemImage)
        
        let itemInfo = UILabel()
        itemInfo.numberOfLines = 0
        itemInfo.translatesAutoresizingMaskIntoConstraints = false
        itemInfo.textColor = UIColor.black
        itemInfo.text = "Rocket Sticker\n$10.00"
        itemDetailsStackView.addArrangedSubview(itemInfo)
        
        self.payButton.translatesAutoresizingMaskIntoConstraints = true
        self.payButton.addTarget(self, action: #selector(selectPaymentMethodAction), for: .touchUpInside)
        self.payButton.setTitle("Select Payment Method", for: .normal)
        self.payButton.setTitleColor(UIColor.white, for: .normal)
        self.payButton.backgroundColor = UIColor.blue
        self.checkoutStackView.addArrangedSubview(self.payButton)
    }
    
    func selectPaymentMethodAction() {
        guard let paymentMethodNonce = self.paymentMethod?.nonce else {
            showDropIn(clientTokenOrTokenizationKey: "YOUR_AUTHORIZATION_KEY_HERE")
            return
        }
        createTransaction(params: ["payment_method_nonce" : paymentMethodNonce])
    }
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                self.paymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
                
                let paymentMethodStackView = UIStackView()
                self.checkoutStackView.insertArrangedSubview(paymentMethodStackView, at: self.checkoutStackView.arrangedSubviews.count-1)
                paymentMethodStackView.translatesAutoresizingMaskIntoConstraints = false
                paymentMethodStackView.axis  = .horizontal
                paymentMethodStackView.spacing = 20
                
                selectedPaymentMethodIcon.widthAnchor.constraint(equalToConstant: 45).isActive = true
                selectedPaymentMethodIcon.heightAnchor.constraint(equalToConstant: 29).isActive = true
                paymentMethodStackView.addArrangedSubview(selectedPaymentMethodIcon)
                
                let selectedPaymentMethodText = UILabel()
                selectedPaymentMethodText.numberOfLines = 0
                selectedPaymentMethodText.translatesAutoresizingMaskIntoConstraints = false
                selectedPaymentMethodText.textColor = UIColor.black
                selectedPaymentMethodText.text = selectedPaymentMethodDescription
                paymentMethodStackView.addArrangedSubview(selectedPaymentMethodText)
                
                self.payButton.setTitle("Buy Now", for: .normal)
                self.payButton.backgroundColor = UIColor.purple
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func createTransaction(params: Dictionary<String, Any>) {
        Alamofire.request("http://localhost:3000/payments/checkout", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            if let JSON = response.result.value {
                self.alert(message: "JSON: \(JSON)")
            } else {
                self.alert(message: "FAILURE")
            }
        }
    }
}

