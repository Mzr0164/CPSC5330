import Foundation

// MARK: - BMI Category Enum
enum BMICategory: String, CaseIterable {
    case underweight = "Underweight"
    case normalWeight = "Normal Weight"
    case overweight = "Overweight"
    case obese = "Obese"
    case unknown = "Unknown"
}

// MARK: - BMI Model
struct BMIModel {
    private var bmi: Double = 0.0
    
    // Calculate BMI based on weight, height, and unit system
    mutating func calculateBMI(weight: Double, height: Double, isMetric: Bool) -> Double {
        if isMetric {
            // Metric: BMI = weight (kg) / height (m)²
            bmi = weight / (height * height)
        } else {
            // Imperial: BMI = (weight (lbs) * 703) / height (inches)²
            bmi = (weight * 703) / (height * height)
        }
        return bmi
    }
    
    // Get BMI category based on calculated value
    func getBMICategory() -> BMICategory {
        switch bmi {
        case 0..<18.5:
            return .underweight
        case 18.5..<25:
            return .normalWeight
        case 25..<30:
            return .overweight
        case 30...:
            return .obese
        default:
            return .unknown
        }
    }
    
    // Get BMI category as string
    func getBMICategoryString() -> String {
        return getBMICategory().rawValue
    }
    
    // Get BMI value rounded to 1 decimal place
    func getBMIValue() -> String {
        return String(format: "%.1f", bmi)
    }
    
    // Get raw BMI value for calculations
    func getRawBMIValue() -> Double {
        return bmi
    }
}
