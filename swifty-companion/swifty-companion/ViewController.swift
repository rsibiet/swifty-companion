//
//  ViewController.swift
//  swifty-companion
//
//  Created by Remy SIBIET on 16/02/2018.
//  Copyright © 2018 Remy SIBIET. All rights reserved.
//

import UIKit

let UID = "..." // YOUR UID
let SECRET = "..." // YOUR SECRET

//  Issue with UIImageView background in rotation
extension UIView {
    func addBackground(imageName: String, contentMode: UIViewContentMode) {
        let imageViewBackground = UIImageView()
        imageViewBackground.image = UIImage(named: imageName)
        
        // you can change the content mode:
        imageViewBackground.contentMode = contentMode
        imageViewBackground.clipsToBounds = true
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        
        self.insertSubview(imageViewBackground, at: 0)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[imageViewBackground]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["imageViewBackground": imageViewBackground]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageViewBackground]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["imageViewBackground": imageViewBackground]))
    }
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.white
        nav?.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        
//    add background image using extention UIView
        self.view.addBackground(imageName: "fond.jpg", contentMode: UIViewContentMode.scaleAspectFill)
        
        self.textField.delegate = self;
        textField.layer.cornerRadius = 8
        button.layer.cornerRadius = 80
        
        getToken()
    }
    
//    set a limite len for text Field
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 25
    }
    
//    hide keyboard when touch enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func getToken() {
        //          Start NetworkActivityIndicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = NSURL(string: "https://api.intra.42.fr/oauth/token")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.httpBody = "grant_type=client_credentials&client_id=\(UID)&client_secret=\(SECRET)".data(using: String.Encoding.utf8, allowLossyConversion: false)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            if let err = error {
                print(err)
            }
            else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        dataSt.token = (dic["access_token"] as? String)!
                        dataSt.expire = (dic["expires_in"] as? Double)!
                        dataSt.dateToken = Date().timeIntervalSinceReferenceDate
                        //          Stop NetworkActivityIndicator
                        DispatchQueue.main.async {
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func searchLoginButton(_ sender: UIButton) {
        dataSt.login = textField.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

