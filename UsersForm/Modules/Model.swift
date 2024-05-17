//
//  Model.swift
//  UsersForm
//
//  Created by Ramina Tastanova on 14.05.2024.
//

import Foundation
import CoreData

enum URLConstants {
    static let countriesAPI = "https://restcountries.com/v2/all"
}

class UserDataFormModelImpl: UserDataFormModel {
    func fetchCountries(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: URLConstants.countriesAPI) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let countriesData = try JSONDecoder().decode([Country].self, from: data)
                let countryNames = countriesData.map { $0.name }
                completion(countryNames)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func saveUserData(name: String, country: String, phoneNumber: String, email: String, completion: @escaping (Bool) -> Void) {
        let context = CoreDataManager.shared.context
        let user = UserEntity(context: context)
        user.name = name
        user.country = country
        user.phoneNumber = phoneNumber
        user.email = email
        
        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save user: \(error)")
            completion(false)
        }
    }
    
    func fetchUsers() -> [UserEntity] {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
}

struct Country: Codable {
    let name: String
}
