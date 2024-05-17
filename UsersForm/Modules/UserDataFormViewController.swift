//
//  UserDataFormViewController.swift
//  UsersForm
//
//  Created by Ramina Tastanova on 14.05.2024.
//

import UIKit
import SnapKit

// MARK: - Constants

enum FormConstants {
    static let name = "Name"
    static let phoneNumber = "Phone Number"
    static let email = "Email"
    static let saveButtonTitle = "Save"
    static let buttonCornerRadius: CGFloat = 8.0
    static let errorFontSize: CGFloat = 12.0
    static let buttonWidth: CGFloat = 120.0
    static let buttonHeight: CGFloat = 40.0
    static let textHeight: CGFloat = 40.0
    static let textOffset: CGFloat = 20.0
    static let errorOffset: CGFloat = 5.0
}

class UserDataFormViewController: UIViewController, UserDataFormView {
    
    var user: UserEntity?
    
    // MARK: - Properties
    
    private var countries: [String] = []
    private var selectedCountryIndex: Int?
    
    // MARK: - UI Elements
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = FormConstants.name
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let countryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = FormConstants.phoneNumber
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = FormConstants.email
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(FormConstants.saveButtonTitle, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = FormConstants.buttonCornerRadius
        return button
    }()
    
    private let nameErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: FormConstants.errorFontSize)
        return label
    }()
    
    private let countryErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: FormConstants.errorFontSize)
        return label
    }()
    
    private let phoneNumberErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: FormConstants.errorFontSize)
        return label
    }()
    
    private let emailErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: FormConstants.errorFontSize)
        return label
    }()
    
    // MARK: - Presenter
    
    private var presenter: UserDataFormPresenter!
    
    // MARK: - Initializers
    
    init(user: UserEntity?) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func loadUsers() {
        if let user = user {
            nameTextField.text = user.name
            phoneNumberTextField.text = user.phoneNumber
            emailTextField.text = user.email
        }
        let users = presenter.fetchUsers()
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        presenter = UserDataFormPresenterImpl(view: self, model: UserDataFormModelImpl(), viewController: UserDataFormViewController(user: user))
        
        setupUI()
        presenter.viewDidLoad()
        
        loadUsers()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(countryPicker)
        view.addSubview(phoneNumberTextField)
        view.addSubview(emailTextField)
        view.addSubview(saveButton)
        view.addSubview(nameErrorLabel)
        view.addSubview(countryErrorLabel)
        view.addSubview(phoneNumberErrorLabel)
        view.addSubview(emailErrorLabel)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(FormConstants.textOffset)
            make.leading.equalToSuperview().offset(FormConstants.textOffset)
            make.trailing.equalToSuperview().inset(FormConstants.textOffset)
            make.height.equalTo(FormConstants.textHeight)
        }
        
        countryPicker.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(FormConstants.textOffset)
            make.leading.trailing.equalTo(nameTextField)
        }
        
        phoneNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(countryPicker.snp.bottom).offset(FormConstants.textOffset)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(FormConstants.textHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(FormConstants.textOffset)
            make.leading.trailing.equalTo(nameTextField)
            make.height.equalTo(FormConstants.textHeight)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(FormConstants.textOffset)
            make.centerX.equalToSuperview()
            make.width.equalTo(FormConstants.buttonWidth)
            make.height.equalTo(FormConstants.textHeight)
        }
        
        nameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(FormConstants.errorOffset)
            make.leading.trailing.equalTo(nameTextField)
        }
        
        countryErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(countryPicker.snp.bottom).offset(FormConstants.errorOffset)
            make.leading.trailing.equalTo(countryPicker)
        }
        
        phoneNumberErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberTextField.snp.bottom).offset(FormConstants.errorOffset)
            make.leading.trailing.equalTo(phoneNumberTextField)
        }
        
        emailErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(FormConstants.errorOffset)
            make.leading.trailing.equalTo(emailTextField)
        }
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        presenter.saveButtonTapped(name: nameTextField.text,
                                   countryIndex: selectedCountryIndex,
                                   phoneNumber: phoneNumberTextField.text,
                                   email: emailTextField.text)
    }
    
    func updateErrorLabels(nameError: String?, countryError: String?, phoneNumberError: String?, emailError: String?) {
        nameErrorLabel.text = nameError
        countryErrorLabel.text = countryError
        phoneNumberErrorLabel.text = phoneNumberError
        emailErrorLabel.text = emailError
    }
    
    // MARK: - UserDataFormView
    
    func updateCountriesList(_ countries: [String]) {
        self.countries = countries
        DispatchQueue.main.async {
            self.countryPicker.reloadAllComponents()
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension UserDataFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountryIndex = row
    }
}
