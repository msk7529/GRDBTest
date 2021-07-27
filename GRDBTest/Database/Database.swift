//
//  Database.swift
//  GRDBTest
//
//  Created by kakao on 2021/07/27.
//
import GRDB

final class Database {
    static let shared: Database = .init()
    private(set) var dbQueue: DatabaseQueue?
        
    func open() throws {
        guard dbQueue == nil else { return }
        
        let databaseURL = try FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        
        dbQueue = try? DatabaseQueue(path: databaseURL.path)

        if let dbQueue = dbQueue {
            do {
                try migrator.migrate(dbQueue)
            } catch {
                print("Error occured in migration!")
            }
        }
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("createTable") { db in
            let columns = UserInfo.Columns.self
            
            try db.create(table: UserInfo.databaseTableName) { table in
                table.column(columns.id.rawValue, .integer).notNull().primaryKey()
                table.column(columns.fullname.rawValue, .text).notNull()
                table.column(columns.isMale.rawValue, .boolean).notNull()
                table.column(columns.address.rawValue, .text)
                table.column(columns.hobby.rawValue, .text)
            }
        }
        return migrator
    }
}
