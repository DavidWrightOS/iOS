//
//  PhoneNumberUpdateViewController.swift
//  WaterMyPlant
//
//  Created by Lambda_School_Loaner_201 on 3/7/20.
//  Copyright © 2020 Christian Lorenzo. All rights reserved.
//

import UIKit

class PhoneNumberUpdateViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet private weak var phoneNumberTextField: UITextField!
    
    @IBAction func phoneNumberTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        guard let newNumber = phoneNumberTextField.text else { return }
        updateNumber(with: newNumber) { error in
            
        }
        let alert = UIAlertController(title: "Success", message: "Phone number has been updated!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateNumber(with phoneNumber: String, completion: @escaping (Error?) -> Void) {
        let baseURL = URL(string: "https://webpt9-water-my-plants.herokuapp.com/api")!
        
        guard let user = user, let id = user.id, let token = LoginController.shared.token?.token else { return }
        let requestURL = baseURL.appendingPathComponent("/auth/\(id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        let json = """
        {
        "phoneNumber": "\(phoneNumber)"
        }
        """
        let jsonData = json.data(using: .utf8)
        guard let unwrapped = jsonData else {
            print("No data!")
            return
        }
        request.httpBody = unwrapped
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Fail")
                
                
            } else {
                print("Success")
                
            }
        }.resume()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
