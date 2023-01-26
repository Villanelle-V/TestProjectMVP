//
//  PersonalDataMO+CoreDataProperties.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//
//

import Foundation
import CoreData


extension PersonalDataMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonalDataMO> {
        return NSFetchRequest<PersonalDataMO>(entityName: "PersonalDataMO")
    }

    @NSManaged public var address: String
    @NSManaged public var email: String
    @NSManaged public var phone: String
    @NSManaged public var name: String

}

extension PersonalDataMO : Identifiable {

}
