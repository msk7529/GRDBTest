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
        print("db path: \(databaseURL)")
        
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
    
    func insert(info: UserInfo) {
        do {
            try dbQueue?.write { db in
                try info.insert(db)
                print("\(info.fullname) UserInfo updated.\nMain Thread: \(Thread.isMainThread)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        do {
            _ = try dbQueue?.write { db in
                do {
                    let deleteRowsCount = try UserInfo.deleteAll(db)
                    print("Delete All UserInfo (\(deleteRowsCount)).\nMain Thread: \(Thread.isMainThread)")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAll() -> [UserInfo] {
        var results = [UserInfo]()
        do {
            try dbQueue?.read { db in
                results = try UserInfo.fetchAll(db)
                print("Fetch All UserInfo (\(results.count)).\nMain Thread: \(Thread.isMainThread)")
            }
        } catch {
            print(error.localizedDescription)
        }
        return results
    }
    
    func fetchAllCount() -> Int {
        var results = 0
        do {
            try dbQueue?.read { db in
                results = try UserInfo.fetchCount(db)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return results
    }
    
    func save(info: UserInfo) {
        do {
            try dbQueue?.write { db in
                try info.save(db)
                print("\(info.fullname) UserInfo Updated. \nMain Thread: \(Thread.isMainThread)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(info: UserInfo) {
        do {
            _ = try dbQueue?.write { db in
                try UserInfo.deleteOne(db, key: info.id)
                print("\(info.fullname) UserInfo Deleted.\nMain Thread: \(Thread.isMainThread)")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
