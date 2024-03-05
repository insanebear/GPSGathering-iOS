//
//  ViewController.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
    var isTracking: Bool = false {
        didSet {
            updateStatus()
        }
    }

    lazy var locationManager: LocationManager = LocationManager.shared
    var container: NSPersistentContainer! {
        didSet {
            locationManager.container = self.container
        }
    }
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setupContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
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
    
    
    @objc func didTapButton(_ sender: UITapGestureRecognizer) {
        isTracking.toggle()
    }
    
    @objc func didTapPrintButton(_ sender: UITapGestureRecognizer) {
        fetchData()
    }

    private func updateStatus() {
        if isTracking {
            button.isSelected = true
            locationManager.startTracking()
        } else {
            button.isSelected = false
            locationManager.stopTracking()
        }
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

