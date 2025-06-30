//
//  CurrencyModel.swift
//  CurrencyConverter
//

import Foundation

struct Currency {
    let name: String
    let code: String
    let rate: Double
    var isSelected: Bool
}

class CurrencyModel {
    // Exchange rates relative to USD (as of example date)
    private var currencies: [Currency] = [
        Currency(name: "Euro", code: "EUR", rate: 0.85, isSelected: false),
        Currency(name: "British Pound", code: "GBP", rate: 0.73, isSelected: false),
        Currency(name: "Japanese Yen", code: "JPY", rate: 110.0, isSelected: false),
        Currency(name: "Canadian Dollar", code: "CAD", rate: 1.25, isSelected: false)
    ]
    
    func getAllCurrencies() -> [Currency] {
        return currencies
    }
    
    func toggleCurrencySelection(at index: Int) {
        guard index < currencies.count else { return }
        currencies[index].isSelected.toggle()
    }
    
    func getSelectedCurrencies() -> [Currency] {
        return currencies.filter { $0.isSelected }
    }
    
    func convertAmount(_ amount: Double) -> [(currency: Currency, convertedAmount: Double)] {
        let selectedCurrencies = getSelectedCurrencies()
        return selectedCurrencies.map { currency in
            (currency: currency, convertedAmount: amount * currency.rate)
        }
    }
    
    func resetSelections() {
        for i in 0..<currencies.count {
            currencies[i].isSelected = false
        }
    }
}


