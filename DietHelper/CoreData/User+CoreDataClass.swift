//
//  User+CoreDataClass.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/01.
//
//

import UIKit
import CoreData

@objc(User)
public class User: NSManagedObject {
    var profile = Profile() {
        didSet {
            let userArray = fetchData()
            if userArray.isEmpty {
                saveData()
                print("empty")
                return
            }
            
            for user in userArray {
                if Calendar.current.isDateInToday(oldValue.date) == Calendar.current.isDateInToday(user.date!) {
                    updateData(age: user.age, weight: user.weight, height: user.height, exerciseLevel: user.exerciseLevel)
                    print("not empty")
                } else {
                    saveData()
                    print("not empty but save")
                }
            }
        }
    }
    
    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        
        guard let entity else { return }
        
        let model = profile
        let profile = NSManagedObject(entity: entity, insertInto: context)
        
        profile.setValue(model.age, forKey: "age")
        profile.setValue(model.weight, forKey: "weight")
        profile.setValue(model.height, forKey: "height")
        profile.setValue(model.isMale, forKey: "isMale")
        profile.setValue(model.date, forKey: "date")
        profile.setValue(model.exerciseLevel, forKey: "exerciseLevel")
        profile.setValue(model.consumedCalories, forKey: "consumedCalories")
        profile.setValue(model.gainedCalories, forKey: "gainedCalories")
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func fetchData() -> [User] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let user = try context.fetch(User.fetchRequest()) as! [User]
            return user
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    func fetchDataThroughDate(date: Date) -> User? {
        let datas = fetchData()
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else { return nil }
        do {
            for user in datas {
                if user.date == date {
                    return user
                }
            }
        }
        return nil
    }
    
    func updateData(date: Date = Date(), age: Int64, weight: Double, height: Double, exerciseLevel: Float) {
        
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as NSDate)
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            
            let userByDate = data[0] as! NSManagedObject
            userByDate.setValue(age, forKey: "age")
            userByDate.setValue(weight, forKey: "weight")
            userByDate.setValue(height, forKey: "height")
            userByDate.setValue(date, forKey: "date")
            userByDate.setValue(exerciseLevel, forKey: "exerciseLevel")
            
            print("=============data============\n", data)
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func updateCalories(date: Date, gainedCalories: Int, consumedCalories: Int) {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let lastData = fetchData().last!
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as NSDate)
        do {
            let data = try managedContext.fetch(fetchRequest)
            if data.isEmpty {
                profile = Profile(age: Int(lastData.age), exerciseLevel: lastData.exerciseLevel, height: lastData.height, weight: lastData.weight, isMale: lastData.isMale, date: date, gainedCalories: gainedCalories , consumedCalories: consumedCalories)
                return
            }
            
            let userByDate = data[0] as! NSManagedObject
            
            
            userByDate.setValue(consumedCalories, forKey: "consumedCalories")
            userByDate.setValue(gainedCalories, forKey: "gainedCalories")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    func updateCalories(gained: Int64, consumed: Int64) {
        let calendar = Calendar.current
        let userArray = fetchData()
        do {
            for user in userArray {
                if calendar.isDateInToday(user.date!) == calendar.isDateInToday(Date()) {
                    user.consumedCalories = consumed
                    user.gainedCalories = gained
                }
            }
        }
    }
    
}
