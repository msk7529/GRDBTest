//
//  ViewController.swift
//  GRDBTest
//
//  Created by kakao on 2021/07/27.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.backgroundColor = .systemBlue
        createButton.layer.cornerRadius = 10
    }

    @IBAction func didTapCreateButton(_ sender: UIButton) {
        let randomNum: Int64 = Int64.random(in: 0..<Int64.max)
        let userInfo: UserInfo
        if randomNum.isMultiple(of: 2) {
            userInfo = .init(id: randomNum,
                                           fullname: "BoYoung_\(randomNum % 1000000)",
                                           isMale: false)
        } else {
            userInfo = .init(id: randomNum,
                                           fullname: "MinSeop_\(randomNum % 1000000)",
                                           isMale: true,
                                           address: "Seoul_\(randomNum % 1000000)",
                                           hobby: nil)
        }
        
        Database.shared.insert(info: userInfo)
    }
}

