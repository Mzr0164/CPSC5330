//
//  InputView.swift
//  CurrencyConverter
//

import UIKit

protocol InputViewDelegate: AnyObject {
    func didTapConvertButton()
    func didToggleCurrency(at index: Int)
    func textFieldDidChange()
}

class InputView: UIView {
    
    weak var delegate: InputViewDelegate?
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency Converter"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .lightBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter amount in USD"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor.primaryBlue.cgColor
        textField.layer.borderWidth = 2.0
        textField.layer.cornerRadius = 8.0
        textField.keyboardType = .numberPad
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        
        return textField
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert Currency", for: .normal)
        button.backgroundColor = .primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currencySwitches: [UISwitch] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        backgroundColor = .backgroundBlue
        
        addSubview(titleLabel)
        addSubview(amountTextField)
        addSubview(errorLabel)
        addSubview(currencyStackView)
        addSubview(convertButton)
        
        setupCurrencyOptions()
        setupKeyboardToolbar()
    }
    
    private func setupCurrencyOptions() {
        let currencies = ["Euro (EUR)", "British Pound (GBP)", "Japanese Yen (JPY)", "Canadian Dollar (CAD)"]
        
        for (index, currencyName) in currencies.enumerated() {
            let containerView = createCurrencyRow(title: currencyName, tag: index)
            currencyStackView.addArrangedSubview(containerView)
        }
    }
    
    private func createCurrencyRow(title: String, tag: Int) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .lightBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let switchControl = UISwitch()
        switchControl.onTintColor = .primaryBlue
        switchControl.thumbTintColor = .white
        switchControl.tag = tag
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        currencySwitches.append(switchControl)
        
        containerView.addSubview(label)
        containerView.addSubview(switchControl)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            switchControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return containerView
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [flexSpace, doneButton]
        amountTextField.inputAccessoryView = toolbar
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Amount TextField
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            amountTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            amountTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            amountTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Error Label
            errorLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Currency Stack View
            currencyStackView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 40),
            currencyStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            currencyStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Convert Button
            convertButton.topAnchor.constraint(greaterThanOrEqualTo: currencyStackView.bottomAnchor, constant: 40),
            convertButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            convertButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            convertButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40),
            convertButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        amountTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        for switchControl in currencySwitches {
            switchControl.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
    }
    
    // MARK: - Actions
    @objc private func convertButtonTapped() {
        delegate?.didTapConvertButton()
    }
    
    @objc private func textFieldChanged() {
        delegate?.textFieldDidChange()
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        delegate?.didToggleCurrency(at: sender.tag)
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    // MARK: - Public Methods
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        
        errorLabel.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.errorLabel.alpha = 1
        }
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func resetSwitches() {
        currencySwitches.forEach { $0.isOn = false }
    }
    
    func getAmountText() -> String? {
        return amountTextField.text
    }
}
