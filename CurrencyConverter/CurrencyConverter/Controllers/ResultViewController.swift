//
//  ResultViewController.swift
//  CurrencyConverter
//

import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    private var convertedAmounts: [(currency: Currency, convertedAmount: Double)] = []
    private var originalAmount: Double = 0.0
    private var resultView: ResultView!
    
    // MARK: - Lifecycle
    override func loadView() {
        resultView = ResultView()
        resultView.delegate = self
        view = resultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        displayResults()
    }
    
    // MARK: - Setup Methods
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func displayResults() {
        resultView.configure(with: convertedAmounts, originalAmount: originalAmount)
    }
    
    // MARK: - Configuration
    func configure(with amounts: [(currency: Currency, convertedAmount: Double)], originalAmount: Double) {
        self.convertedAmounts = amounts
        self.originalAmount = originalAmount
    }
}

// MARK: - ResultViewDelegate
extension ResultViewController: ResultViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
