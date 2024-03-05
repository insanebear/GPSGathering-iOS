//
//  ViewController.swift
//  GPSGathering-iOS
//
//  Created by Yurim Jayde Jeong on 2024/03/05.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    var isTracking: Bool = false {
        didSet {
            updateStatus()
        }
    }
    lazy var locationManager: LocationManager = LocationManager.shared
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
    }
    
    private func setupButton() {
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    @objc func didTapButton(_ sender: UITapGestureRecognizer) {
        isTracking.toggle()
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
}

