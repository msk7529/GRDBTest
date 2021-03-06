//
//  ViewController.swift
//  GRDBTest
//
//  Created by kakao on 2021/07/27.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var deleteAllButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var userInfo: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButton.backgroundColor = .systemBlue
        createButton.layer.cornerRadius = 10
        
        deleteAllButton.backgroundColor = .systemRed
        deleteAllButton.layer.cornerRadius = 10
        
        fetchUserInfos()
    }
    
    private func fetchUserInfos() {
        userInfo = Database.shared.fetchAll()
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
        
        self.userInfo.append(userInfo)
        
        let indexPath: IndexPath = .init(row: self.userInfo.count - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .none)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @IBAction func didTapDeleteAllButton(_ sender: UIButton) {
        Database.shared.deleteAll()
        
        self.userInfo.removeAll()
        
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoTableViewCell.identifier, for: indexPath) as? UserInfoTableViewCell else {
            return UITableViewCell()
        }
        
        cell.userInfo = self.userInfo[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserInfoTableViewCell else { return }
        
        self.showUpdateAlert(cell.userInfo)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Database.shared.delete(info: self.userInfo[indexPath.row])
            
            self.userInfo.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController {
    public func showUpdateAlert(_ info: UserInfo) {
        let alertController: UIAlertController = .init(title: "??????/?????? ??????", message: "?????? ?????? ????????? ???????????????.\n????????? ????????? ????????????", preferredStyle: .alert)
                
        alertController.addTextField { textField in
            textField.placeholder = "?????? ?????? ????????? ???????????????."
            textField.isSecureTextEntry = false
        }

        let addAddressAction: UIAlertAction = .init(title: "????????????", style: .default, handler: { [weak alertController, weak self] _ in
            if let textField = alertController?.textFields?.first, let address = textField.text {
                if address.isEmpty {
                    if let index = self?.userInfo.firstIndex(where: { $0.id == info.id }) {
                        self?.userInfo[index].updateAddress(to: nil)
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                } else {
                    if let index = self?.userInfo.firstIndex(where: { $0.id == info.id }) {
                        self?.userInfo[index].updateAddress(to: address)
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
            }
        })
        
        let addHobbyAction: UIAlertAction = .init(title: "????????????", style: .default, handler: { [weak alertController, weak self] _ in
            if let textField = alertController?.textFields?.first, let hobby = textField.text {
                if hobby.isEmpty {
                    if let index = self?.userInfo.firstIndex(where: { $0.id == info.id }) {
                        self?.userInfo[index].updateHobby(to: nil)
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                } else {
                    if let index = self?.userInfo.firstIndex(where: { $0.id == info.id }) {
                        self?.userInfo[index].updateHobby(to: hobby)
                        self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                    }
                }
            }
        })
        
        let cancelAction: UIAlertAction = .init(title: "??????", style: .cancel, handler: nil)
        
        alertController.addAction(addAddressAction)
        alertController.addAction(addHobbyAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
