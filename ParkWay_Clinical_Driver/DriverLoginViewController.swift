//
//  DriverLoginViewController.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/2/23.
//

import UIKit

class DriverLoginViewController: UIViewController {
    
    var data: LoginResponse?
    var client = ClientNetwork(network: Network())
  //  var driverDetails: DriverDetails?
    
    var parkWayImage: UIImageView = {
        var parkWayImg = UIImageView()
        parkWayImg.image = UIImage(named:"ParkWay")
        parkWayImg.translatesAutoresizingMaskIntoConstraints = false
        return parkWayImg
    }()
    
    var phoneTextField: UITextField = {
        var phoneText = UITextField()
        phoneText.placeholder = "Enter Phone Number"
        return phoneText
    }()
    
    var passwordTextField: UITextField = {
        var passwordText = UITextField()
        passwordText.isSecureTextEntry = true
        passwordText.placeholder = "Enter Password"
        return passwordText
    }()
    
    var loginButton: UIButton = {
        var button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor(named: "Maroon")
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        return button
    }()
    
    var signButton: UIButton = {
        var signbutton = UIButton()
        signbutton.setTitle("SignUp", for: .normal)
        signbutton.backgroundColor = .red
        signbutton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        return signbutton
    }()
    
    let loginSignupStackView: UIStackView = {
        let loginSignupStack = UIStackView()
        loginSignupStack.axis = .horizontal
        loginSignupStack.alignment = .fill
        loginSignupStack.distribution = .fillEqually
        loginSignupStack.spacing = 3
        // mainStack.translatesAutoresizingMaskIntoConstraints = false
        return loginSignupStack
    }()
    
    let mainStackView: UIStackView = {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        mainStackView.addArrangedSubview(parkWayImage)
        mainStackView.addArrangedSubview(phoneTextField)
        mainStackView.addArrangedSubview(passwordTextField)
        loginSignupStackView.addArrangedSubview(loginButton)
        loginSignupStackView.addArrangedSubview(signButton)
        mainStackView.addArrangedSubview(loginSignupStackView)
        self.view.addSubview(mainStackView)
        mainStackView.backgroundColor = .white
        view.backgroundColor = .white
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
             mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -50),
             mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 50),
             mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -50),
             passwordTextField.bottomAnchor.constraint(equalTo: loginSignupStackView.bottomAnchor,constant: -30),
             phoneTextField.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 230),
             parkWayImage.heightAnchor.constraint(equalToConstant: 150)])
    }
    
    @objc func signupTapped(){
        let signVC = SignUpViewController()
        self.navigationController?.pushViewController(signVC, animated: true)
    }
    
    
    @objc func loginTapped(){
        guard let phoneNumber = self.phoneTextField.text else {
            return
        }
        guard let password = self.passwordTextField.text else {
            return
        }
        
        client.driverLogin(phoneNumber: phoneNumber, password: password, completionHandler: {
            driverLoginResult in
            switch driverLoginResult{
            case .success(let driverloginModel):
                
                DispatchQueue.main.async {
                    let vc = DriverRouteViewController(routeId: driverloginModel.RouteNo)
                    let newNavVC = UINavigationController(rootViewController: vc)
                    newNavVC.modalPresentationStyle = .fullScreen
                    self.present(newNavVC, animated: true)
                }
                
                
            case .failure(_):
                self.showErrorAlert(message: "Login API Failed")
            }
        })
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Something went wrong!",
                                      message: message,
                                      preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "Try Again",
                                    style: .default)
        alert.addAction(alertOk)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
}
