//
//  SignUpViewController.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/2/23.
//

import UIKit

class SignUpViewController: UIViewController {

    var data: DriverAuthentication?
    var client = ClientNetwork(network: Network())
    var parkWayImage: UIImageView = {
        var parkWayImg = UIImageView()
        parkWayImg.image = UIImage(named:"ParkWay")
        parkWayImg.translatesAutoresizingMaskIntoConstraints = false
        return parkWayImg
    }()
    
    var phoneNumberTextField: UITextField = {
        var loginText = UITextField()
        loginText.placeholder = "Enter Phone Number"
        return loginText
    }()

    var passwordTextField: UITextField = {
        var passwordText = UITextField()
        passwordText.isSecureTextEntry = true
        passwordText.placeholder = "Password"
        return passwordText
    }()
    
    var confirmPasswordTextField: UITextField = {
        var confirmpasswordText = UITextField()
        confirmpasswordText.isSecureTextEntry = true
        confirmpasswordText.placeholder = "Confirm Password"
        return confirmpasswordText
    }()
    
    var passwordstackView: UIStackView = {
        var passwordsv = UIStackView()
        passwordsv.axis = .vertical
        passwordsv.alignment = .fill
        passwordsv.distribution = .fillEqually
    //    passwordsv.translatesAutoresizingMaskIntoConstraints = false
        return passwordsv
    }()
    
    var doneButton: UIButton = {
        var button = UIButton()
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor(named: "Maroon")
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    var stackView: UIStackView = {
        var sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackView.addArrangedSubview(parkWayImage)
        passwordstackView.addArrangedSubview(phoneNumberTextField)
        passwordstackView.addArrangedSubview(passwordTextField)
        passwordstackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(passwordstackView)
        stackView.addArrangedSubview(doneButton)
        self.view.addSubview(stackView)
        view.backgroundColor = .white
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
             stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
             stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 10),
             stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -10),
             parkWayImage.heightAnchor.constraint(equalToConstant: 150),
             passwordstackView.heightAnchor.constraint(equalToConstant: 200),
             doneButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -350),
             doneButton.heightAnchor.constraint(equalToConstant: 25)
            ])
    }
    
    @objc func doneTapped(){
        
        if passwordTextField.text == confirmPasswordTextField.text{
            signUpDone()
        }else{
            let alert = UIAlertController(title: "Alert", message: "Password and Confirm Password missmatch", preferredStyle: .alert)
            let TryAgainAction = UIAlertAction(title: "Try Again", style: .cancel)
            alert.addAction(TryAgainAction)
            self.present(alert, animated: true)
        }
    }
 
    func signUpDone(){
        guard let phoneNumber = self.phoneNumberTextField.text else {
            return
        }
        guard let password = self.passwordTextField.text else {
            return
        }
        guard let confirmpassword = self.confirmPasswordTextField.text else {
            return
        }
        
        client.driverSignUp(phoneNumber: phoneNumber, password: password, confirmPassword: confirmpassword, completionHandler: { signUpDriverResult in
            switch signUpDriverResult{
            case .success(let signUpdata):
                self.data = signUpdata
                DispatchQueue.main.async {
                    if self.data?.Result.lowercased() == "success"{
                        let driverVC = DriverLoginViewController()
                        self.navigationController?.pushViewController(driverVC, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Alert!", message: self.data?.Result, preferredStyle: .alert)
                        let reTryAction = UIAlertAction(title: "Retry", style: .cancel)
                        
                        alert.addAction(reTryAction)
                        self.present(alert, animated: true)
                    }

                }
            case .failure(_):
                print("Error")
            }
        })
    }
    
}
