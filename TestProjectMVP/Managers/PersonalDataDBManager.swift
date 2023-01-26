//
//  PersonalDataDBManager.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation
import CoreData
import UIKit

protocol PersonalDataDBManagerProtocol {
    var managedContext: NSManagedObjectContext { get }
    
    func create(with data: PersonalData)
    func save()
    func delete(data: PersonalData)
    func fetch() -> [PersonalData]
}

class PersonalDataDBManager: PersonalDataDBManagerProtocol {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let persistentContainer: NSPersistentContainer = {
        let container = appDelegate.persistentContainer
        container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    let managedContext = persistentContainer.newBackgroundContext()
    
    func create(with data: PersonalData) {
        let dbPersonalData = NSEntityDescription.insertNewObject(forEntityName: "PersonalDataMO", into: managedContext) as! PersonalDataMO
        dbPersonalData.name = data.name
        dbPersonalData.phone = data.phone
        dbPersonalData.email = data.email
        dbPersonalData.address = data.address
        save()
    }
    
    func delete(data: PersonalData) {
        let request: NSFetchRequest<PersonalDataMO> = PersonalDataMO.fetchRequest()
        request.predicate = NSPredicate(format: "phone = %@", data.phone)
        
        if let results = try? managedContext.fetch(request) {
            results.forEach { managedContext.delete($0) }
        }
        save()
    }
    
    func save() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch let error as NSError {
                managedContext.rollback()
                print("Could not save \(error)")
            }
        }
    }
    
    func fetch() -> [PersonalData] {
        let request = NSFetchRequest<PersonalDataMO>(entityName: "PersonalDataMO")
        
        do {
            let results = try managedContext.fetch(request)
            return results.map { return PersonalData(with: $0) }
        } catch let error as NSError {
            print("Could not fetch \(error)")
        }
        return [PersonalData]()
    }
}
