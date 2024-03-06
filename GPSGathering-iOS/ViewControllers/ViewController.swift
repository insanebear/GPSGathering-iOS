//
//  ViewController.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import UIKit
import SnapKit
import CoreData

protocol ViewControllerDelegate {
    func updateStatus(isTracking: Bool)
}

class ViewController: UIViewController {

    lazy var locationManager: LocationManager = LocationManager.shared
    var container: NSPersistentContainer!
    
    let button: UIButton = {
        let inset: CGFloat = 20
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        let button = UIButton()
        button.configuration = config
        button.setTitle("Stop", for: .selected)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
    } ()
    
    let printButton: UIButton = {
        let inset: CGFloat = 20
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)

        let button = UIButton()
        button.configuration = config
        button.setTitle("Print", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        
        return button
    } ()
    
    // MARK: - methods
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupContainer()
        self.setupLocationManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupButtons()
    }
    
    // MARK: setup methods
    private func setupLocationManager() {
        self.locationManager.container = self.container
        self.locationManager.uiDelegate = self
    }
    
    private func setupContainer() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Cannot find appDelegate")
        }
        self.container = appDelegate.persistentContainer
    }
    
    private func setupButtons() {
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        printButton.addTarget(self, action: #selector(didTapPrintButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        self.view.addSubview(printButton)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        printButton.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: action methods
    @objc func didTapButton(_ sender: UITapGestureRecognizer) {
        if button.isSelected {
            locationManager.stopTracking()
        } else {
            locationManager.startTracking()
        }
    }
    
    @objc func didTapPrintButton(_ sender: UITapGestureRecognizer) {
        fetchData()
    }
    
    func fetchData() {
        do {
            let locations = try self.container.viewContext.fetch(UserLocation.fetchRequest())
            locations.forEach { location in
                print(location.latitude, location.longitude, location.time)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: ViewControllerDelegate {
    func updateStatus(isTracking: Bool) {
        button.isSelected = isTracking
    }
}
