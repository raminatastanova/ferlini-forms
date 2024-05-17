//
//  Presenter.swift
//  UsersForm
//
//  Created by Ramina Tastanova on 14.05.2024.
//

import Foundation
import UIKit

// MARK: - Constants

enum Constants {
    static let nameRequiredError = "Name is required"
    static let selectCountryError = "Please select a country"
    static let phoneNumberRequiredError = "Phone number is required"
    static let invalidPhoneNumberFormatError = "Invalid phone number format"
    static let emailRequiredError = "Email is required"
    static let invalidEmailFormatError = "Invalid email format"
    static let phoneNumberRegexPattern = #"^\+\d{1,3}\d{9}$"#
}

class UserDataFormPresenterImpl: UserDataFormPresenter {
    
    private weak var view: UserDataFormView?
    private let model: UserDataFormModel
    private var countries: [String] = []
    private weak var viewController: UIViewController?
    
    init(view: UserDataFormView, model: UserDataFormModel, viewController: UIViewController?) {
        self.view = view
        self.model = model
        self.viewController = viewController
    }
    
    func viewDidLoad() {
        model.fetchCountries { [weak self] countries in
            self?.countries = countries
            self?.view?.updateCountriesList(countries)
        }
    }
    
    func saveButtonTapped(name: String?, countryIndex: Int?, phoneNumber: String?, email: String?) {
        var nameError: String?
        var countryError: String?
        var phoneNumberError: String?
        var emailError: String?
        
        // Validate name
        if let name = name, name.isEmpty {
            nameError = Constants.nameRequiredError
        }
        
        // Validate country
        if let countryIndex = countryIndex {
            if countryIndex < 0 || countryIndex >= countries.count {
                countryError = Constants.selectCountryError
            }
        } else {
            countryError = Constants.selectCountryError
        }
        
        // Validate phone number
        if let phoneNumber = phoneNumber, !phoneNumber.isEmpty {
            let phonePredicate = NSPredicate(format:"SELF MATCHES %@", Constants.phoneNumberRegexPattern)
            if !phonePredicate.evaluate(with: phoneNumber) {
                phoneNumberError = Constants.invalidPhoneNumberFormatError
            }
        } else {
            phoneNumberError = Constants.phoneNumberRequiredError
        }
        
        // Validate email
        if let email = email, !email.isEmpty {
            if !email.contains("@") || !email.contains(".") {
                emailError = Constants.invalidEmailFormatError
            }
        } else {
            emailError = Constants.emailRequiredError
        }
        
        view?.updateErrorLabels(nameError: nameError, countryError: countryError, phoneNumberError: phoneNumberError, emailError: emailError)
        
        if nameError == nil, countryError == nil, phoneNumberError == nil, emailError == nil {
            if let countryIndex = countryIndex, let name = name, let phoneNumber = phoneNumber, let email = email {
                let country = countries[countryIndex]
                model.saveUserData(name: name, country: country, phoneNumber: phoneNumber, email: email) { [weak self] success in
                    if success {
                        print("Data saved successfully")
                    } else {
                        print("Failed to save data")
                    }
                }
            }
        }
    }
    
    func fetchUsers() -> [UserEntity] {
        return model.fetchUsers()
    }
}
