//
//  ResultView.swift
//  CurrencyConverter
//

import UIKit

protocol ResultViewDelegate: AnyObject {
    func didTapBackButton()
}

class ResultView: UIView {
    
    weak var delegate: ResultViewDelegate?
    
    // MARK: - UI Elements
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Conversion Results"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .lightBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let originalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .lightBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let resultsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back to Converter", for: .normal)
        button.backgroundColor = .primaryBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        addSubview(originalAmountLabel)
        addSubview(scrollView)
        addSubview(backButton)
        
        scrollView.addSubview(resultsStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Original Amount Label
            originalAmountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            originalAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            originalAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: originalAmountLabel.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -20),
            
            // Results Stack View
            resultsStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            resultsStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            resultsStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            resultsStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            resultsStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
            
            // Back Button
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            backButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            backButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
    
    // MARK: - Public Methods
    func configure(with results: [(currency: Currency, convertedAmount: Double)], originalAmount: Double) {
        originalAmountLabel.text = String(format: "USD %.0f", originalAmount)
        
        // Clear existing views
        resultsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add result views
        for result in results {
            let resultCard = createResultCard(for: result)
            resultsStackView.addArrangedSubview(resultCard)
        }
        
        // Add height constraint for stack view content
        let cardHeight: CGFloat = 100
        let totalHeight = CGFloat(results.count) * cardHeight + CGFloat(results.count - 1) * 20 // spacing
        resultsStackView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    private func createResultCard(for result: (currency: Currency, convertedAmount: Double)) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.shadowBlue.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 1.0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let currencyLabel = UILabel()
        currencyLabel.text = result.currency.name
        currencyLabel.font = UIFont.boldSystemFont(ofSize: 18)
        currencyLabel.textColor = .lightBlue
        currencyLabel.textAlignment = .center
        
        let codeLabel = UILabel()
        codeLabel.text = result.currency.code
        codeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        codeLabel.textColor = .secondaryBlue
        codeLabel.textAlignment = .center
        
        let amountLabel = UILabel()
        amountLabel.text = String(format: "%.2f", result.convertedAmount)
        amountLabel.font = UIFont.boldSystemFont(ofSize: 24)
        amountLabel.textColor = .accentBlue
        amountLabel.textAlignment = .center
        
        stackView.addArrangedSubview(currencyLabel)
        stackView.addArrangedSubview(codeLabel)
        stackView.addArrangedSubview(amountLabel)
        
        containerView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            containerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        return containerView
    }
}
