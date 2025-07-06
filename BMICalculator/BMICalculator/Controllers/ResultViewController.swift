import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let bmiValueLabel = UILabel()
    private let bmiCategoryLabel = UILabel()
    private let categoryColorView = UIView()
    private let categoryDescriptionLabel = UILabel()
    private let recalculateButton = UIButton(type: .system)
    
    // MARK: - Properties
    var bmiModel: BMIModel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        displayResults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        // Setup scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // Setup content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup BMI value label
        bmiValueLabel.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        bmiValueLabel.textAlignment = .center
        bmiValueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup BMI category label
        bmiCategoryLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        bmiCategoryLabel.textAlignment = .center
        bmiCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup category color view
        categoryColorView.layer.cornerRadius = 20
        categoryColorView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup category description label
        categoryDescriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        categoryDescriptionLabel.textAlignment = .center
        categoryDescriptionLabel.numberOfLines = 0
        categoryDescriptionLabel.textColor = UIColor.systemGray
        categoryDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup recalculate button
        recalculateButton.setTitle("Recalculate BMI", for: .normal)
        recalculateButton.backgroundColor = UIColor.systemBlue
        recalculateButton.setTitleColor(.white, for: .normal)
        recalculateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        recalculateButton.layer.cornerRadius = 12
        recalculateButton.translatesAutoresizingMaskIntoConstraints = false
        recalculateButton.addTarget(self, action: #selector(recalculateButtonTapped), for: .touchUpInside)
        
        // Add all views to hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(bmiValueLabel)
        contentView.addSubview(categoryColorView)
        contentView.addSubview(bmiCategoryLabel)
        contentView.addSubview(categoryDescriptionLabel)
        contentView.addSubview(recalculateButton)
    }
    
    private func setupNavigationBar() {
        title = "BMI Result"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // BMI value label constraints
            bmiValueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            bmiValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bmiValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Category color view constraints
            categoryColorView.topAnchor.constraint(equalTo: bmiValueLabel.bottomAnchor, constant: 30),
            categoryColorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryColorView.widthAnchor.constraint(equalToConstant: 200),
            categoryColorView.heightAnchor.constraint(equalToConstant: 80),
            
            // BMI category label constraints
            bmiCategoryLabel.centerXAnchor.constraint(equalTo: categoryColorView.centerXAnchor),
            bmiCategoryLabel.centerYAnchor.constraint(equalTo: categoryColorView.centerYAnchor),
            
            // Category description label constraints
            categoryDescriptionLabel.topAnchor.constraint(equalTo: categoryColorView.bottomAnchor, constant: 30),
            categoryDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Recalculate button constraints
            recalculateButton.topAnchor.constraint(equalTo: categoryDescriptionLabel.bottomAnchor, constant: 40),
            recalculateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            recalculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            recalculateButton.heightAnchor.constraint(equalToConstant: 50),
            recalculateButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    @objc private func recalculateButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Display Results
    private func displayResults() {
        guard let bmiModel = bmiModel else {
            return
        }
        
        // Display BMI value
        bmiValueLabel.text = bmiModel.getBMIValue()
        
        // Display BMI category
        let category = bmiModel.getBMICategory()
        bmiCategoryLabel.text = category.rawValue
        
        // Set category color based on BMI category
        let color = getColorForBMICategory(category)
        bmiCategoryLabel.textColor = color
        categoryColorView.backgroundColor = color.withAlphaComponent(0.2)
        categoryColorView.layer.borderWidth = 2
        categoryColorView.layer.borderColor = color.cgColor
        
        // Display category description
        categoryDescriptionLabel.text = getCategoryDescription(category)
    }
    
    // Get color for BMI category (UI logic in view controller)
    private func getColorForBMICategory(_ category: BMICategory) -> UIColor {
        switch category {
        case .underweight:
            return UIColor.systemBlue
        case .normalWeight:
            return UIColor.systemGreen
        case .overweight:
            return UIColor.systemOrange
        case .obese:
            return UIColor.systemRed
        case .unknown:
            return UIColor.systemGray
        }
    }
    
    private func getCategoryDescription(_ category: BMICategory) -> String {
        switch category {
        case .underweight:
            return "Your BMI indicates that you may be underweight. Consider consulting with a healthcare provider about healthy weight gain strategies."
        case .normalWeight:
            return "Great! Your BMI is within the healthy weight range. Maintain your current lifestyle with regular exercise and a balanced diet."
        case .overweight:
            return "Your BMI indicates that you may be overweight. Consider incorporating more physical activity and a balanced diet into your routine."
        case .obese:
            return "Your BMI indicates obesity. It's recommended to consult with a healthcare provider for personalized advice on achieving a healthy weight."
        case .unknown:
            return "Unable to determine BMI category."
        }
    }
}
