//
//  DriverRouteTableViewCell.swift
//  ParkWay_Clinical_Driver
//
//  Created by Deepesh Haryani on 2/7/23.
//

import UIKit


class DriverRouteTableViewCell: UITableViewCell {

    static let identifier = "DriverRouteTableViewCell"
    
    var data: CustomerResponse? {
        didSet {
            setValue()
        }
    }
    var CustomernameLabel: UILabel = {
        var name = UILabel()
        name.textColor = .black
        return name
    }()
    
    var streetLabel: UILabel = {
        var street = UILabel()
        street.textColor = UIColor(named: "Blue")
        return street
    }()
    
    var distanceLabel: UILabel = {
        var distance = UILabel()
        distance.textColor = .black
        return distance
    }()
    
    let firstStackView: UIStackView = {
        var firstStack = UIStackView()
        firstStack.axis = .vertical
        firstStack.alignment = .fill
        firstStack.distribution = .fillEqually
        firstStack.spacing = 5
        return firstStack
    }()
    
    let collectedornotLabel: UILabel = {
        var collected = UILabel()
        collected.textColor = .green
        
        return collected
    }()
    
    
    var timeLabel: UILabel = {
        var time = UILabel()
        time.textColor = .black
        return time
    }()
    
    let secondStackView: UIStackView = {
        var secondStack = UIStackView()
        secondStack.axis = .vertical
        secondStack.alignment = .fill
        secondStack.distribution = .fillEqually
        secondStack.spacing = 5
        return secondStack
    }()
    
    let mainStackView: UIStackView = {
        var mainStack = UIStackView()
        mainStack.axis = .horizontal
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        mainStack.spacing = 5
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        return mainStack
    }()
    
    
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        firstStackView.addArrangedSubview(CustomernameLabel)
        firstStackView.addArrangedSubview(streetLabel)
        firstStackView.addArrangedSubview(distanceLabel)
        mainStackView.addArrangedSubview(firstStackView)
        secondStackView.addArrangedSubview(collectedornotLabel)
        secondStackView.addArrangedSubview(timeLabel)
        mainStackView.addArrangedSubview(secondStackView)
        self.addSubview(mainStackView)
        
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setValue(){
        guard let data = data else {
            return
        }
        self.CustomernameLabel.text = data.CustomerName
        self.streetLabel.text = data.StreetAddress
        self.distanceLabel.text = data.City
        self.timeLabel.text = data.PickUpTime
        self.collectedornotLabel.text = data.CollectionStatus
    }
}

