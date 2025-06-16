//
//  ViewController.swift
//  MoodTracker
//
//  Created by Meghan Rockwood on 6/15/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moodSlider: UISlider!
    @IBOutlet weak var moodDisplayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var savedMoodLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateMoodDisplay()
        
        // iPad-specific adjustments
        if UIDevice.current.userInterfaceIdiom == .pad {
            view.backgroundColor = UIColor.systemGroupedBackground
            
            // Adjust font sizes for iPad
            titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
            moodDisplayLabel.font = UIFont.systemFont(ofSize: 24)
            savedMoodLabel.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    private func setupUI() {
        // Configure slider
        moodSlider.minimumValue = 0
        moodSlider.maximumValue = 100
        moodSlider.value = 50
        
        // Configure date picker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        // Configure button
        saveButton.backgroundColor = UIColor.systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        
        // Configure saved mood label
        savedMoodLabel.numberOfLines = 0
        savedMoodLabel.textAlignment = .center
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateMoodDisplay()
    }
    
    @IBAction func saveMoodTapped(_ sender: UIButton) {
        saveMood()
    }
    
    private func updateMoodDisplay() {
        let value = Int(moodSlider.value)
        let moodData = getMoodData(for: value)
        moodDisplayLabel.text = "\(moodData.description) \(moodData.emoji)"
    }
    
    private func getMoodData(for value: Int) -> (description: String, emoji: String) {
        switch value {
        case 0...20:
            return ("Very Sad", "😢")
        case 21...40:
            return ("Sad", "🙁")
        case 41...60:
            return ("Neutral", "😐")
        case 61...80:
            return ("Happy", "🙂")
        case 81...100:
            return ("Very Happy", "😄")
        default:
            return ("Neutral", "😐")
        }
    }
    
    private func saveMood() {
        let moodValue = Int(moodSlider.value)
        let selectedDate = datePicker.date
        let moodData = getMoodData(for: moodValue)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        let dateString = dateFormatter.string(from: selectedDate)
        savedMoodLabel.text = "On \(dateString), you felt \(moodData.emoji)"
        
        // Optional: Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Adjust layout for rotation
        if traitCollection.verticalSizeClass == .compact {
            // Landscape orientation - adjust spacing if needed
        }
    }
}
