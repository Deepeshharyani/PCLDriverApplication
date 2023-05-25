//
//  CustomerRouteViewController.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/8/23.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

struct Location{
    var lat: Double
    var long: Double
}

class CustomerRouteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    var client = ClientNetwork(network: Network())
    var data: CustomerResponse?
    var delegate: DriverRouteViewControllerDelegate?
    var driverData: RouteResponse?
    var ReachedCustomer:Bool = false
    var usersLocation: Location? = nil {
        didSet {
            self.InitalizeMaps()
        }
    }
    
    var selectedValueInPickerView: ((String) -> Void)?
    
    let dataArray = ["Not Collected", "Collected", "Reschedule", "Missed", "Closed","Arrived","Other"]
    
    var CustomernameLabel: UILabel = {
        var name = UILabel()
        name.textColor = .black
        name.textAlignment = .center
        return name
    }()
    
    var streetLabel: UILabel = {
        var street = UILabel()
        street.textAlignment = .center
        street.textColor = UIColor(named: "Blue")
        return street
    }()
    
    
    var mapview: MKMapView = {
        var map = MKMapView()
        return map
    }()
    
    var specimenLabel: UILabel = {
        var specimen = UILabel()
        specimen.text = "Specimen Status"
        specimen.textColor = .black
        return specimen
    }()
    
    let specimenStackView: UIStackView = {
        var firstStack = UIStackView()
        firstStack.axis = .horizontal
        firstStack.alignment = .fill
        firstStack.distribution = .fillEqually
        firstStack.spacing = 5
        firstStack.isHidden = true
        return firstStack
    }()
    
    var numbOfspecimenLabel: UILabel = {
        var specimenCollected = UILabel()
        specimenCollected.text = "No. of Specimen"
        specimenCollected.textColor = .black
        return specimenCollected
    }()
    
    var numbertOfSpecimenCollectedTextField: UITextField = {
        var numbertOfSpecimenCollected = UITextField()
        numbertOfSpecimenCollected.layer.borderWidth = 1.0
        return numbertOfSpecimenCollected
    }()
    
    let collectionSpecimenStackView: UIStackView = {
        var firstStack = UIStackView()
        firstStack.axis = .horizontal
        firstStack.alignment = .fill
        firstStack.distribution = .fillEqually
        firstStack.spacing = 5
        firstStack.isHidden = true
        return firstStack
    }()
    
    
    
    var updateButton: UIButton = {
        var update = UIButton()
        update.setTitle("Update", for: .normal)
        update.setTitleColor(.white, for: .normal)
        update.backgroundColor = UIColor(named: "Maroon")
        return update
    }()
    
    let mainStackView: UIStackView = {
        var mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.spacing = 5
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()
    
    let uiPicker: UIPickerView = UIPickerView()
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStackView.addArrangedSubview(CustomernameLabel)
        mainStackView.addArrangedSubview(streetLabel)
        mainStackView.addArrangedSubview(mapview)
        specimenStackView.addArrangedSubview(specimenLabel)
        specimenStackView.addArrangedSubview(uiPicker)
        mainStackView.addArrangedSubview(specimenStackView)
        collectionSpecimenStackView.addArrangedSubview(numbOfspecimenLabel)
        collectionSpecimenStackView.addArrangedSubview(numbertOfSpecimenCollectedTextField)
        mainStackView.addArrangedSubview(collectionSpecimenStackView)
        mainStackView.addArrangedSubview(updateButton)
        self.view.addSubview(mainStackView)
        uiPicker.delegate = self as UIPickerViewDelegate
        uiPicker.dataSource = self as UIPickerViewDataSource
        
        self.CustomernameLabel.text = data?.CustomerName
        self.streetLabel.text = data?.StreetAddress
        
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = .white
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate(
            [mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
             mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
             mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 15),
             mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -15)])
        
    }
    
    @objc func updateButtonTapped(){
        var index = uiPicker.selectedRow(inComponent: 0)
      //  index = index + 1
//        var pickerData = ""
//        for i in 0..<dataArray.count{
//            if i == index{
//                pickerData = dataArray[i]
//            }
//        }
        print(uiPicker.selectedRow(inComponent: 0))
        guard let cutomerid = data?.CustomerId,
//              let pickerData = UIPicker.selectedRow(inComponent: 0),
              
              let routeid = driverData?.RouteNo else {
            return
        }
        let numberofSpecimens = Int(self.numbertOfSpecimenCollectedTextField.text ?? "") ?? 0
        let status = index
        //let status = "Collected"
        let updateby = String(describing: driverData?.DriverId)
        client.requestAddTransaction(CustomerId: cutomerid, NumberOfSpecimens: numberofSpecimens, RouteId: routeid, Status: status, UpdateBy: updateby, completionHandler: {
            transactionResult in
            DispatchQueue.main.async{
                switch transactionResult {
                case .success(let transactionData):
                    var alert = UIAlertController(title: "Success",
                                                  message: "",
                                                  preferredStyle: .alert)
                    let alertOk = UIAlertAction(title: "Ok",
                                                style: .default)
                    {_ in
                       
                      self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(alertOk)
                    self.delegate?.updatestatus(routeData: self.driverData!)
                    self.present(alert, animated: true)
                case .failure(_):
                    let alert = UIAlertController(title: "Something went wrong!",
                                                  message: "",
                                                  preferredStyle: .alert)
                    let alertOk = UIAlertAction(title: "Try Again",
                                                style: .default)
                    alert.addAction(alertOk)
                    self.present(alert, animated: true)
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        mapview.delegate = self
        manager.distanceFilter = 100
        
        if let lat = data?.Cust_Lat , let lon = data?.Cust_Log {
            let geoFencingRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: 10, identifier: "GEO")
            manager.startMonitoring(for: geoFencingRegion)
        }
        InitalizeMaps()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        specimenStackView.isHidden = false
        collectionSpecimenStackView.isHidden = false
        
        checkforPermission()
        
        if let name = data?.CustomerName{
            ReachedCustomer = true
            let title = "You have reached the customer \(name)"
            let body = " Wanna update Specimen collected"
            putNotifications(title: title, subtitle: body)
        }
        
        
        //            let content = UNMutableNotificationContent()
        //            content.title = "You have reached customer \(data?.CustomerName ?? "")"
        //            content.subtitle = "Update delivery Status"
        //            content.sound = UNNotificationSound.default
        //            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        //            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        //            UNUserNotificationCenter.current().add(request)
    }
    
    func checkforPermission(){
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings {setting in
            switch setting.authorizationStatus{
            case .authorized:
                self.dispatchNotification()
            case .denied:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert,.sound]) {
                    didAllow, error in
                    if didAllow{
                        self.dispatchNotification()
                    }
                }
            default:
                return
            }
        }
    }
    
    func dispatchNotification(){
        let identifier = "Morning"
        let title = "You have reached the Customer"
        let body = "Update Specimen Count"
        let hour = 16
        let minute = 36
        let isDaily  = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let calendar = Calendar.current
        var datecomponents = DateComponents(calendar: calendar, timeZone: TimeZone.current)
        datecomponents.hour = hour
        datecomponents.minute = minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: isDaily)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print(region.identifier)
        specimenStackView.isHidden = true
        collectionSpecimenStackView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if usersLocation != nil{
            usersLocation!.lat = locations[0].coordinate.latitude
            usersLocation!.long = locations[0].coordinate.longitude
        }else{
            usersLocation = Location(lat: locations[0].coordinate.latitude, long: locations[0].coordinate.longitude)
        }
        
        print("user updated location \(usersLocation)")
    }
    
}
    extension CustomerRouteViewController: UIPickerViewDelegate{
//        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//            selectedValueInPickerView?(String(dataArray[row]))
//            print(selectedValueInPickerView)
//           }
    }

extension CustomerRouteViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = dataArray[row]
        return row
    }
}

extension CustomerRouteViewController {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 5.0
        return renderer
    }
    func addAnote(point: CLLocationCoordinate2D, title: String, subTitle: String = ""){
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subTitle
        annotation.coordinate = point
        self.mapview.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 100
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, completion: @escaping (Bool) -> Void){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                completion(true)
                print("Showing on map--------------------------")
                //show on map
                self.mapview.addOverlay(route.polyline)
                //set the map area to show the route
                self.mapview.setVisibleMapRect(route.polyline.boundingMapRect,
                                               edgePadding: UIEdgeInsets.init(
                                                top: 80.0,
                                                left: 20.0,
                                                bottom: 100.0,
                                                right: 20.0
                                               ),
                                               animated: true)
            }else{
                completion(false)
            }
        }
    }
    
    func InitalizeMaps(){
        if let userlocation = self.usersLocation{
            
            // Get users location cordinates
            let mylocation = CLLocationCoordinate2D(latitude: userlocation.lat, longitude: userlocation.long)
            // Get destinations location cordinates
            let destinationLocation = CLLocationCoordinate2D(latitude: Double(self.data?.Cust_Lat ?? 0), longitude: Double(self.data?.Cust_Log ?? 0))
            // Add user anote
            self.addAnote(point: mylocation, title: "You are here")
            //Show route on map if avialable
            self.showRouteOnMap(pickupCoordinate: mylocation, destinationCoordinate: destinationLocation) { (result) in
                if(result){
                    self.addAnote(point: destinationLocation, title: "Destination")
                }else{
                    let location = CLLocation(latitude: mylocation.latitude, longitude: mylocation.longitude)
                    self.centerMapOnLocation(location, mapView: self.mapview)
                }
            }
            
        }
    }
    
    func putNotifications(title: String, subtitle: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subtitle
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}
//40.78322
//-74.2255668
