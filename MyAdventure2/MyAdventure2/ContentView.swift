//




import SwiftUI


// Protocol for adventure choices
protocol AdventureChoice {
    var title: String { get }
    var description: String { get }
    var isSuccessful: Bool { get }
}

// Enumeration for adventure outcomes
enum AdventureOutcome {
    case success(String)
    case failure(String)
    case ongoing
}

// Error handling for adventure
enum AdventureError: Error {
    case invalidChoice
    case adventureComplete
    
    var localizedDescription: String {
        switch self {
        case .invalidChoice:
            return "Invalid choice selected"
        case .adventureComplete:
            return "Your Forbidden Forest quest is complete"
        }
    }
}

// Struct representing a single adventure step
struct AdventureStep {
    let id: Int
    let story: String
    let choices: [Choice]
    let isEndStep: Bool
    
    init(id: Int, story: String, choices: [Choice], isEndStep: Bool = false) {
        self.id = id
        self.story = story
        self.choices = choices
        self.isEndStep = isEndStep
    }
}

// Class representing individual choices
class Choice: AdventureChoice, ObservableObject {
    let title: String
    let description: String
    let isSuccessful: Bool
    let nextStepId: Int?
    
    init(title: String, description: String, isSuccessful: Bool, nextStepId: Int? = nil) {
        self.title = title
        self.description = description
        self.isSuccessful = isSuccessful
        self.nextStepId = nextStepId
    }
}

// Main Adventure Model Class
class AdventureModel: ObservableObject {
    @Published private var currentStepId: Int = 1
    @Published private var isComplete: Bool = false
    private var adventureSteps: [Int: AdventureStep] = [:]
    
    init() {
        setupForbiddenForestAdventure()
    }
    
    private func setupForbiddenForestAdventure() {
        // Layer 1: Entering the Forbidden Forest
        adventureSteps[1] = AdventureStep(
            id: 1,
            story: "🌲 You stand at the edge of the Forbidden Forest. Your Professor has sent you on a mission to find ancient magic traces. Two paths diverge before you.",
            choices: [
                Choice(title: "🕯️ Take the moonlit path", description: "Follow the safer, well-worn trail", isSuccessful: true, nextStepId: 2),
                Choice(title: "🌙 Take the shadow path", description: "Follow the darker, mysterious route", isSuccessful: true, nextStepId: 3)
            ]
        )
        
        // Layer 2A: Moonlit Path - Encounter with Thestrals
        adventureSteps[2] = AdventureStep(
            id: 2,
            story: "🦄 A magnificent Thestral lands before you. It seems curious but wary. How do you approach this magical creature?",
            choices: [
                Choice(title: "🥕 Offer it food", description: "Show kindness to gain trust", isSuccessful: true, nextStepId: 4),
                Choice(title: "⚡ Cast a defensive spell", description: "Protect yourself from the unknown", isSuccessful: false, nextStepId: 7)
            ]
        )
        
        // Layer 2B: Shadow Path - Acromantula Encounter
        adventureSteps[3] = AdventureStep(
            id: 3,
            story: "🕷️ Giant Acromantulas emerge from the darkness. 'Why do you trespass here?' asks the largest one.",
            choices: [
                Choice(title: "🗣️ Speak respectfully", description: "Explain your peaceful mission", isSuccessful: true, nextStepId: 5),
                Choice(title: "🔥 Attack with magic", description: "Fight your way through", isSuccessful: false, nextStepId: 8)
            ]
        )
        
        // Layer 3A: Thestral Alliance - Ancient Grove
        adventureSteps[4] = AdventureStep(
            id: 4,
            story: "🌟 The Thestral allows you to ride! You reach an ancient grove with glowing magical runes. What's your approach?",
            choices: [
                Choice(title: "🔍 Examine carefully", description: "Study the magic safely", isSuccessful: true, nextStepId: 6),
                Choice(title: "✋ Touch directly", description: "Risk immediate contact", isSuccessful: false, nextStepId: 9)
            ]
        )
        
        // Layer 3B: Acromantula Guidance - Underground Caverns
        adventureSteps[5] = AdventureStep(
            id: 5,
            story: "🕳️ The Acromantulas guide you to hidden caverns with ancient magical symbols. How do you proceed?",
            choices: [
                Choice(title: "🛡️ Enter with protection", description: "Use defensive magic while exploring", isSuccessful: true, nextStepId: 6),
                Choice(title: "💎 Rush toward the crystals", description: "Head straight for the magic", isSuccessful: false, nextStepId: 10)
            ]
        )
        
        // Layer 4: SUCCESS - Ancient Magic Repository
        adventureSteps[6] = AdventureStep(
            id: 6,
            story: "🏆 SUCCESS! You've discovered the Repository of Ancient Magic! Swirling pools of magical energy contain knowledge from Hogwarts founders. Your mission is complete!",
            choices: [],
            isEndStep: true
        )
        
        // Failure endings
        adventureSteps[7] = AdventureStep(
            id: 7,
            story: "💀 Your aggressive spell frightened the Thestral. It flew away and other creatures now avoid you. You're lost in the forest.",
            choices: [],
            isEndStep: true
        )
        
        adventureSteps[8] = AdventureStep(
            id: 8,
            story: "🕸️ Your attack angered the Acromantula colony. You escaped but made enemies. The forest creatures refuse to help you.",
            choices: [],
            isEndStep: true
        )
        
        adventureSteps[9] = AdventureStep(
            id: 9,
            story: "⚡ Touching the ancient magic directly was dangerous! Unstable energy courses through you and you must flee.",
            choices: [],
            isEndStep: true
        )
        
        adventureSteps[10] = AdventureStep(
            id: 10,
            story: "🦇 Rushing triggered ancient defenses! Inferi guardians rise and you're forced to retreat without the ancient magic.",
            choices: [],
            isEndStep: true
        )
    }
    
    func getCurrentStep() -> AdventureStep? {
        return adventureSteps[currentStepId]
    }
    
    func makeChoice(_ choiceIndex: Int) throws -> AdventureOutcome {
        guard !isComplete else {
            throw AdventureError.adventureComplete
        }
        
        guard let currentStep = getCurrentStep(),
              choiceIndex >= 0 && choiceIndex < currentStep.choices.count else {
            throw AdventureError.invalidChoice
        }
        
        let selectedChoice = currentStep.choices[choiceIndex]
        
        if let nextStepId = selectedChoice.nextStepId {
            currentStepId = nextStepId
            if let nextStep = getCurrentStep(), nextStep.isEndStep {
                isComplete = true
                return selectedChoice.isSuccessful ?
                    .success(nextStep.story) : .failure(nextStep.story)
            }
            return .ongoing
        } else {
            isComplete = true
            return selectedChoice.isSuccessful ?
                .success(currentStep.story) : .failure(currentStep.story)
        }
    }
    
    func resetAdventure() {
        currentStepId = 1
        isComplete = false
    }
    
    var adventureIsComplete: Bool {
        return isComplete
    }
}

// MARK: - SwiftUI Views

struct ContentView: View {
    @StateObject private var adventureModel = AdventureModel()
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let currentStep = adventureModel.getCurrentStep() {
                        // Story text
                        Text(currentStep.story)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        
                        // Choice buttons or restart button
                        if currentStep.isEndStep {
                            Button(action: {
                                adventureModel.resetAdventure()
                            }) {
                                HStack {
                                    Text("🔄 Start New Quest")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            .padding(.top, 20)
                        } else {
                            VStack(spacing: 16) {
                                ForEach(Array(currentStep.choices.enumerated()), id: \.offset) { index, choice in
                                    ChoiceButton(choice: choice) {
                                        handleChoice(index)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding()
            }
            .navigationTitle("🌲 Forbidden Forest")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Better for all device sizes
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("Continue") {
                // Alert automatically dismisses
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func handleChoice(_ choiceIndex: Int) {
        do {
            let outcome = try adventureModel.makeChoice(choiceIndex)
            
            switch outcome {
            case .success(let message):
                alertTitle = "🎉 Quest Complete!"
                alertMessage = message
                showingAlert = true
            case .failure(let message):
                alertTitle = "💔 Quest Failed"
                alertMessage = message
                showingAlert = true
            case .ongoing:
                // UI will automatically update due to @Published properties
                break
            }
        } catch {
            alertTitle = "Error"
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}

struct ChoiceButton: View {
    let choice: Choice
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(choice.title)
                    .font(.headline)
                Text(choice.description)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
    }
}

