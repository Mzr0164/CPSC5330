//
//  InputViewController.swift
//  CurrencyConverter
//

import UIKit

class InputViewController: UIViewController {
    
    // MARK: - Properties
    private let currencyModel = CurrencyModel()
    private var enteredAmount: Double = 0.0
    private var customInputView: InputView!
    
    // MARK: - Lifecycle
    override func loadView() {
        customInputView = InputView()
        customInputView.delegate = self
        view = customInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSwitches()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isHidden = true
    }
    
    private func resetSwitches() {
        currencyModel.resetSelections()
        customInputView.resetSwitches()
    }
    
    // MARK: - Validation
    private func validateInput() -> Bool {
        guard let text = customInputView.getAmountText(), !text.isEmpty else {
            customInputView.showError("Please enter an amount")
            return false
        }
        
        guard let amount = Double(text), amount > 0 else {
            customInputView.showError("Please enter a valid positive number")
            return false
        }
        
        // Check if amount is an integer
        if amount != floor(amount) {
            customInputView.showError("Please enter integers only")
            return false
        }
        
        guard currencyModel.getSelectedCurrencies().count > 0 else {
            customInputView.showError("Please select at least one currency")
            return false
        }
        
        enteredAmount = amount
        return true
    }
    
    // MARK: - Navigation
    private func navigateToResults() {
        let convertedAmounts = currencyModel.convertAmount(enteredAmount)
        let resultViewController = ResultViewController()
        resultViewController.configure(with: convertedAmounts, originalAmount: enteredAmount)
        navigationController?.pushViewController(resultViewController, animated: true)
    }
}

// MARK: - InputViewDelegate
extension InputViewController: InputViewDelegate {
    func didTapConvertButton() {
        guard validateInput() else { return }
        navigateToResults()
    }
    
    func didToggleCurrency(at index: Int) {
        currencyModel.toggleCurrencySelection(at: index)
    }
    
    func textFieldDidChange() {
        customInputView.hideError()
    }
}
