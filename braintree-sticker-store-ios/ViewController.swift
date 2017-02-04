import UIKit
import Alamofire

class ViewController: UIViewController {
    
    let checkoutStackView = UIStackView()
    let selectPaymentMethodButton = UIButton(type: .roundedRect)

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
        
        let itemImage = UIImageView(image: UIImage(named: ""))
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        itemImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        itemImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        itemDetailsStackView.addArrangedSubview(itemImage)
        
        let itemInfo = UILabel()
        itemInfo.numberOfLines = 0
        itemInfo.translatesAutoresizingMaskIntoConstraints = false
        itemInfo.textColor = UIColor.black
        itemInfo.text = "Rocket Sticker\n$1000"
        itemDetailsStackView.addArrangedSubview(itemInfo)
        
        self.selectPaymentMethodButton.translatesAutoresizingMaskIntoConstraints = true
        self.selectPaymentMethodButton.addTarget(self, action: #selector(selectPaymentMethodAction), for: .touchUpInside)
        self.selectPaymentMethodButton.setTitle("Select Payment Method", for: .normal)
        self.selectPaymentMethodButton.setTitleColor(UIColor.white, for: .normal)
        self.selectPaymentMethodButton.backgroundColor = UIColor.blue
        self.checkoutStackView.addArrangedSubview(self.selectPaymentMethodButton)
    }
    
    func selectPaymentMethodAction() {
        self.alert(message: "Select Payment Method")
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
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

