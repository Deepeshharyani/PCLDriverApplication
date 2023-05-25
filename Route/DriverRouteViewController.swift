//
//  DriverRouteViewController.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/7/23.
//

import UIKit


protocol DriverRouteViewControllerDelegate{
    func updatestatus(routeData: RouteResponse)
}

class DriverRouteViewController: UIViewController {
    
    var client = ClientNetwork(network: Network())

    var routeData: routeDetails? {
        didSet{
            setValues()
        }
    }
    
    init(routeId: Int) {
        super.init(nibName: nil, bundle: nil)
        getRouteDetails(routeId: routeId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   lazy var RouteNameLabel: UILabel = {
        var RouteNameText = UILabel()
        RouteNameText.textColor = .white
        return RouteNameText
    }()
    lazy var RouteNumberTextField: UILabel = {
        var RouteNumberText = UILabel()
        RouteNumberText.textColor = .white

        return RouteNumberText
    }()
    
    lazy var vehicleNumberTextField: UILabel = {
        var vehicleNumberText = UILabel()
        vehicleNumberText.textColor = .white
        
        return vehicleNumberText
    }()
    lazy var numberOfCustomersTextField: UILabel = {
        var numberOfCustomersText = UILabel()
        numberOfCustomersText.textColor = .white
        
        return numberOfCustomersText
    }()
    

    let routeDetailStackView: UIStackView = {
        var routeDetailStack = UIStackView()
        routeDetailStack.axis = .vertical
        routeDetailStack.alignment = .center
        routeDetailStack.distribution = .fillEqually
        routeDetailStack.spacing = 10
        routeDetailStack.backgroundColor = UIColor(named: "Maroon")
    //    stack.translatesAutoresizingMaskIntoConstraints = false
        return routeDetailStack
    }()
    var mainStackView: UIStackView = {
        var mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 30
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func getRouteDetails(routeId: Int){
        client.requestgetRouteDetails(RouteNumber: routeId, completionHandler: { routeDetailResult in
            DispatchQueue.main.async {
                switch routeDetailResult{
                case .success(let routeDetail):
                    
                    self.routeData = routeDetail
                    
                case .failure(let errorString):
                    let alert = UIAlertController(title: "Alert", message: errorString, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Cancel", style: .cancel)
                    
                    alert.addAction(alertAction)
                    self.present(alert, animated: true)
                }
            }
            
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        routeDetailStackView.addArrangedSubview(RouteNameLabel)
        routeDetailStackView.addArrangedSubview(RouteNumberTextField)
        routeDetailStackView.addArrangedSubview(vehicleNumberTextField)
        routeDetailStackView.addArrangedSubview(numberOfCustomersTextField)
        mainStackView.addArrangedSubview(routeDetailStackView)
        mainStackView.addArrangedSubview(tableview)
        self.view.addSubview(mainStackView)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(DriverRouteTableViewCell.self, forCellReuseIdentifier: DriverRouteTableViewCell.identifier)
        
        view.backgroundColor = .white
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
             mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
             mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
             mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)])
    }
    
    func setValues(){
        RouteNameLabel.text =  "Route Name: \(String(describing : routeData?.Route.RouteName ?? ""))"
        RouteNumberTextField.text = "Route Number: \(String(describing: routeData?.Route.RouteNo ?? 0))"
        vehicleNumberTextField.text = "Vehicle: \(String(describing: routeData?.Route.VehicleNo ?? ""))"
        numberOfCustomersTextField.text = "No. of Customers in Route: \(String(describing: routeData?.Customer.count ?? 0))"
        
        tableview.reloadData()
    }
}
extension DriverRouteViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerRouteVC = CustomerRouteViewController()
      customerRouteVC.delegate = self
        customerRouteVC.data = routeData?.Customer[indexPath.row]
        customerRouteVC.driverData = routeData?.Route
        self.navigationController?.pushViewController(customerRouteVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DriverRouteViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeData?.Customer.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DriverRouteTableViewCell.identifier) as? DriverRouteTableViewCell else {
            return UITableViewCell()
        }
        cell.data = routeData?.Customer[indexPath.row]
        cell.collectedornotLabel.text = routeData?.Customer[indexPath.row].CollectionStatus
        return cell
    }
}
extension DriverRouteViewController: DriverRouteViewControllerDelegate{
    func updatestatus(routeData: RouteResponse) {
        self.getRouteDetails(routeId: routeData.RouteNo ?? 0)
    }
    
    
    
    //    func updatestatus(customerData: CustomerResponse) {
    //        self.getRouteDetails(routeId: routeData?.Route.RouteNo ?? 0)
    //    }
    //
    //    func updatestatus(customerData: CustomerResponse) {
    //        for cell in tableview.visibleCells {
    //            if let cell = cell as? DriverRouteTableViewCell,
    //               cell.CustomernameLabel.text == customerData.CustomerName {
    //                cell.collectedornotLabel.text = "Collected"
    //            }
    //        }
    //    }
    
}
