//
//  DBItem.swift
//  GRDBTest
//
//  Created by kakao on 2021/07/27.
//
import Foundation
import GRDB

struct UserInfo: Codable, PersistableRecord, FetchableRecord {
    var id: Int64
    var fullname: String
    var isMale: Bool
    var address: String?
    var hobby: String?
        
    enum Columns: String, ColumnExpression {
        case id, fullname, isMale, address, hobby
    }
    
    init(id: Int64, fullname: String, isMale: Bool, address: String? = nil, hobby: String? = nil) {
        self.id = id
        self.fullname = fullname
        self.isMale = isMale
        self.address = address
        self.hobby = hobby
    }
    
    init(row: Row) {
        id = row[Columns.id]
        fullname = row[Columns.fullname]
        isMale = row[Columns.isMale]
        address = row[Columns.address]
        hobby = row[Columns.hobby]
    }
    
    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.fullname] = fullname
        container[Columns.isMale] = isMale
        container[Columns.address] = address
        container[Columns.hobby] = hobby
    }
    
    mutating func updateAddress(to address: String?) {
        self.address = address
        
        Database.shared.save(info: self)
    }
    
    mutating func updateHobby(to hobby: String?) {
        self.hobby = hobby
        
        Database.shared.save(info: self)
    }
}
