//
//  UserInfoTableViewCell.swift
//  GRDBTest
//
//  Created by kakao on 2021/07/27.
//

import UIKit

final class UserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var hobbyLabel: UILabel!
    
    var userInfo: UserInfo! {
        didSet {
            initView()
        }
    }
    
    static let identifier: String = "UserInfoTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        self.addressLabel.isHidden = false
        self.hobbyLabel.isHidden = false
    }
    
    private func initView() {
        nameLabel.text = userInfo.fullname
        sexLabel.text = userInfo.isMale ? "Male" : "Female"
        sexLabel.textColor = userInfo.isMale ? .blue : .red
        
        if let address = userInfo.address {
            addressLabel.text = address
        } else {
            addressLabel.isHidden = true
        }
        
        if let hobby = userInfo.hobby {
            hobbyLabel.text = hobby
        } else {
            hobbyLabel.isHidden = true
        }
    }
}
