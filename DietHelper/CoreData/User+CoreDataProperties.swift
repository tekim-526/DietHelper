//
//  User+CoreDataProperties.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/01.
//
//

import Foundation
import CoreData
import UIKit


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    
    @NSManaged public var age: Int64
    @NSManaged public var exerciseLevel: Float
    @NSManaged public var height: Double
    @NSManaged public var weight: Double
    @NSManaged public var isMale: Bool
    @NSManaged public var date: Date?
    @NSManaged public var gainedCalories: Int64
    @NSManaged public var consumedCalories: Int64
}

extension User : Identifiable {

}
