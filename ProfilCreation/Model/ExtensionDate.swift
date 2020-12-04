//
//  ExtensionDate.swift
//  ProfilCreation
//
//  Created by Idriss Souissi on 25/11/2020.
//

import Foundation

extension Date {
    
    func getAgeFromBirthDate(date: Date)-> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponent = calendar.dateComponents([.year], from: date, to: now)
        guard let age = ageComponent.year else {return 0}
        return age
    }
}
