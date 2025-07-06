import UIKit

class InputViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let instructionLabel = UILabel()
    private let unitSegmentedControl = UISegmentedControl(items: ["Metric", "Imperial"])
    private let weightUnitLabel = UILabel()
    private let weightTextField = UITextField()
    private let heightUnitLabel = UILabel()
    private let heightTextField = UITextField()
    private let errorLabel = UILabel()
    private let calculateButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    
    // MARK: - Properties
    var bmiModel = BMIModel()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupTextFields()
        updateUnitLabels()
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
        
        // Setup title label
        titleLabel.text = "BMI Calculator"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup instruction label
        instructionLabel.text = "Enter your weight and height to calculate your BMI"
        instructionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        instructionLabel.textColor = UIColor.systemGray
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup segmented control
        unitSegmentedControl.selectedSegmentIndex = 0
        unitSegmentedControl.backgroundColor = UIColor.systemGray6
        unitSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        unitSegmentedControl.addTarget(self, action: #selector(unitSegmentedControlChanged), for: .valueChanged)
        
        // Setup weight components
        setupLabel(weightUnitLabel, text: "Weight (kg)")
        setupTextField(weightTextField, placeholder: "Enter weight in kg")
        
        // Setup height components
        setupLabel(heightUnitLabel, text: "Height (m)")
        setupTextField(heightTextField, placeholder: "Enter height in meters")
        
        // Setup error label
        errorLabel.textColor = UIColor.systemRed
        errorLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup calculate button
        calculateButton.setTitle("Calculate BMI", for: .normal)
        calculateButton.backgroundColor = UIColor.systemBlue
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        calculateButton.layer.cornerRadius = 12
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped), for: .touchUpInside)
        
        // Setup reset button
        resetButton.setTitle("Reset", for: .normal)
        resetButton.backgroundColor = UIColor.systemGray
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        resetButton.layer.cornerRadius = 12
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // Add all views to hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(instructionLabel)
        contentView.addSubview(unitSegmentedControl)
        contentView.addSubview(weightUnitLabel)
        contentView.addSubview(weightTextField)
        contentView.addSubview(heightUnitLabel)
        contentView.addSubview(heightTextField)
        contentView.addSubview(errorLabel)
        contentView.addSubview(calculateButton)
        contentView.addSubview(resetButton)
    }
    
    private func setupNavigationBar() {
        title = "BMI Calculator"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = UIColor.systemBlue
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.keyboardType = .decimalPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    private func setupTextFields() {
        // Add toolbar with Done button to text fields
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexSpace, doneButton]
        
        weightTextField.inputAccessoryView = toolbar
        heightTextField.inputAccessoryView = toolbar
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
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Instruction label constraints
            instructionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Unit segmented control constraints
            unitSegmentedControl.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 24),
            unitSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            unitSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            unitSegmentedControl.heightAnchor.constraint(equalToConstant: 44),
            
            // Weight label constraints
            weightUnitLabel.topAnchor.constraint(equalTo: unitSegmentedControl.bottomAnchor, constant: 24),
            weightUnitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Weight text field constraints
            weightTextField.topAnchor.constraint(equalTo: weightUnitLabel.bottomAnchor, constant: 8),
            weightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            weightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            weightTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Height label constraints
            heightUnitLabel.topAnchor.constraint(equalTo: weightTextField.bottomAnchor, constant: 20),
            heightUnitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heightUnitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Height text field constraints
            heightTextField.topAnchor.constraint(equalTo: heightUnitLabel.bottomAnchor, constant: 8),
            heightTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heightTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            heightTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // Error label constraints
            errorLabel.topAnchor.constraint(equalTo: heightTextField.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Calculate button constraints
            calculateButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 24),
            calculateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            calculateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            calculateButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Reset button constraints
            resetButton.topAnchor.constraint(equalTo: calculateButton.bottomAnchor, constant: 16),
            resetButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resetButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Actions
    @objc private func unitSegmentedControlChanged() {
        updateUnitLabels()
        clearTextFields()
    }
    
    @objc private func calculateButtonTapped() {
        calculateBMI()
    }
    
    @objc private func resetButtonTapped() {
        resetForm()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        hideError()
    }
    
    // MARK: - Helper Methods
    private func updateUnitLabels() {
        let isMetric = unitSegmentedControl.selectedSegmentIndex == 0
        
        if isMetric {
            weightUnitLabel.text = "Weight (kg)"
            heightUnitLabel.text = "Height (m)"
            weightTextField.placeholder = "Enter weight in kg"
            heightTextField.placeholder = "Enter height in meters"
        } else {
            weightUnitLabel.text = "Weight (lbs)"
            heightUnitLabel.text = "Height (inches)"
            weightTextField.placeholder = "Enter weight in lbs"
            heightTextField.placeholder = "Enter height in inches"
        }
    }
    
    private func clearTextFields() {
        weightTextField.text = ""
        heightTextField.text = ""
        hideError()
    }
    
    private func resetForm() {
        clearTextFields()
        unitSegmentedControl.selectedSegmentIndex = 0
        updateUnitLabels()
        hideError()
    }
    
    private func hideError() {
        errorLabel.isHidden = true
    }
    
    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
    
    private func validateInputs() -> (weight: Double, height: Double, isValid: Bool) {
        guard let weightText = weightTextField.text, !weightText.isEmpty,
              let heightText = heightTextField.text, !heightText.isEmpty else {
            showError("Please enter both weight and height")
            return (0, 0, false)
        }
        
        guard let weight = Double(weightText), weight > 0 else {
            showError("Please enter a valid weight")
            return (0, 0, false)
        }
        
        guard let height = Double(heightText), height > 0 else {
            showError("Please enter a valid height")
            return (0, 0, false)
        }
        
        let isMetric = unitSegmentedControl.selectedSegmentIndex == 0
        
        // Additional validation for reasonable ranges
        if isMetric {
            if weight < 1 || weight > 500 {
                showError("Weight must be between 1 and 500 kg")
                return (0, 0, false)
            }
            if height < 0.5 || height > 3.0 {
                showError("Height must be between 0.5 and 3.0 meters")
                return (0, 0, false)
            }
        } else {
            if weight < 2 || weight > 1100 {
                showError("Weight must be between 2 and 1100 lbs")
                return (0, 0, false)
            }
            if height < 20 || height > 120 {
                showError("Height must be between 20 and 120 inches")
                return (0, 0, false)
            }
        }
        
        return (weight, height, true)
    }
    
    private func calculateBMI() {
        let validation = validateInputs()
        
        guard validation.isValid else {
            return
        }
        
        let isMetric = unitSegmentedControl.selectedSegmentIndex == 0
        let bmiValue = bmiModel.calculateBMI(weight: validation.weight, height: validation.height, isMetric: isMetric)
        
        // Navigate to result view controller
        let resultViewController = ResultViewController()
        resultViewController.bmiModel = bmiModel
        navigationController?.pushViewController(resultViewController, animated: true)
    }
}
