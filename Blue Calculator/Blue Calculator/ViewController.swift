//
//  ViewController.swift
//  Blue Calculator
//
//  Created by Meghan Rockwood on 6/8/25.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set background color
        view.backgroundColor = UIColor(red: 0.12, green: 0.23, blue: 0.54, alpha: 1.0)
        
        // Configure display label
        displayLabel.text = "0"
        displayLabel.textColor = .white
        displayLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        displayLabel.textAlignment = .right
        displayLabel.backgroundColor = UIColor(red: 0.12, green: 0.25, blue: 0.69, alpha: 1.0)
        displayLabel.layer.cornerRadius = 12
        displayLabel.clipsToBounds = true
        
        // Configure main stack view
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 12
        
        setupButtons()
    }
    
    private func setupButtons() {
        // Clear existing arranged subviews
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Row 1: C, ±, %, ÷
        let row1 = createButtonRow(titles: ["C", "±", "%", "÷"])
        mainStackView.addArrangedSubview(row1)
        
        // Row 2: 7, 8, 9, ×
        let row2 = createButtonRow(titles: ["7", "8", "9", "×"])
        mainStackView.addArrangedSubview(row2)
        
        // Row 3: 4, 5, 6, −
        let row3 = createButtonRow(titles: ["4", "5", "6", "−"])
        mainStackView.addArrangedSubview(row3)
        
        // Row 4: 1, 2, 3, +
        let row4 = createButtonRow(titles: ["1", "2", "3", "+"])
        mainStackView.addArrangedSubview(row4)
        
        // Row 5: 0, ., =
        let row5 = createButtonRow(titles: ["0", ".", "="])
        mainStackView.addArrangedSubview(row5)
    }
    
    private func createButtonRow(titles: [String]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        
        for title in titles {
            let button = createButton(title: title)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    private func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        // Set button colors based on type
        if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."].contains(title) {
            // Number buttons - royal blue
            button.backgroundColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
        } else if ["+", "−", "×", "÷"].contains(title) {
            // Operator buttons - sky blue
            button.backgroundColor = UIColor(red: 0.23, green: 0.51, blue: 0.97, alpha: 1.0)
        } else if title == "=" {
            // Equals button - accent blue
            button.backgroundColor = UIColor(red: 0.11, green: 0.31, blue: 0.85, alpha: 1.0)
        } else {
            // Function buttons - light blue
            button.backgroundColor = UIColor(red: 0.38, green: 0.65, blue: 0.98, alpha: 1.0)
        }
        
        // Set minimum height
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        // Add button action
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        print("Button tapped: \(title)")
        
        // Simple visual feedback
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.5
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.alpha = 1.0
            }
        }
    }
}



