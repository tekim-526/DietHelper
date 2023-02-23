//
//  OnboardingModel.swift
//  DietHelper
//
//  Created by Kim TaeSoo on 2023/02/01.
//

import Foundation

struct Profile {
    var age: Int = 20
    var exerciseLevel: Float = 3
    var height: Double = 170
    var weight: Double = 70
    var isMale: Bool = true
    var date: Date = Date()
    var gainedCalories: Int = 0
    var consumedCalories: Int = 0
    
    init(age: Int = 20, exerciseLevel: Float = 3, height: Double = 170, weight: Double = 70, isMale: Bool = true, date: Date = Date(), gainedCalories: Int = 0, consumedCalories: Int = 0) {
        let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date))!
        
        self.age = age
        self.exerciseLevel = exerciseLevel
        self.height = height
        self.weight = weight
        self.isMale = isMale
        self.date = date
        self.gainedCalories = gainedCalories
        self.consumedCalories = consumedCalories
    }
    
}
