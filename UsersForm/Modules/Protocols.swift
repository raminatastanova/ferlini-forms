//
//  Protocols.swift
//  UsersForm
//
//  Created by Ramina Tastanova on 14.05.2024.
//

import Foundation

protocol UserDataFormView: AnyObject {
    func updateCountriesList(_ countries: [String])
    func updateErrorLabels(nameError: String?, countryError: String?, phoneNumberError: String?, emailError: String?)
}

protocol UserDataFormPresenter {
    func viewDidLoad()
    func saveButtonTapped(name: String?, countryIndex: Int?, phoneNumber: String?, email: String?)
    func fetchUsers() -> [UserEntity]
}

protocol UserDataFormModel {
    func fetchCountries(completion: @escaping ([String]) -> Void)
    func saveUserData(name: String, country: String, phoneNumber: String, email: String, completion: @escaping (Bool) -> Void)
    func fetchUsers() -> [UserEntity]
}
