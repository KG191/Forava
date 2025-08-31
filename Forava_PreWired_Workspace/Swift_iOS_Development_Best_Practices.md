# Swift iOS Development Best Practices Guide
*Consolidated from WhimziVoiceTales project experience*

## Table of Contents
1. [Project Architecture](#project-architecture)
2. [MVVM Implementation](#mvvm-implementation)
3. [SwiftUI Best Practices](#swiftui-best-practices)
4. [Environment Objects & Dependency Injection](#environment-objects--dependency-injection)
5. [API Service Architecture](#api-service-architecture)
6. [Data Persistence](#data-persistence)
7. [Error Handling](#error-handling)
8. [Async/Await Implementation](#asyncawait-implementation)
9. [Context Engineering & AI-Native Development](#context-engineering--ai-native-development)
10. [Natural Language Development Rules](#natural-language-development-rules)
11. [File Management](#file-management)
12. [Apple App Store Compliance](#apple-app-store-compliance)
13. [GitHub Integration](#github-integration)
14. [Backend Deployment (Railway)](#backend-deployment-railway)
15. [In-App Purchases](#in-app-purchases)
16. [Localization & Multicultural Support](#localization--multicultural-support)
17. [Testing Strategy](#testing-strategy)
18. [iPad Compatibility](#ipad-compatibility)
19. [Performance Optimization](#performance-optimization)
20. [Privacy & Security](#privacy--security)

---

## Project Architecture

### Directory Structure
```
WhimziVoiceTalesSwift/
├── Models/              # Data structures (Codable structs)
├── Views/               # SwiftUI views (UI components)
├── ViewModels/          # MVVM view models (ObservableObject classes)
├── Services/            # Business logic and API services
├── Utilities/           # Helper functions and extensions
├── Resources/           # Assets, images, sounds
├── Extensions/          # Swift extensions
├── Configuration/       # App configuration files
└── Tests/               # Unit and UI tests
```

### Key Architectural Principles
- **MVVM Pattern**: Separation of concerns with ViewModels as intermediaries
- **Single Responsibility**: Each class/struct has one clear purpose
- **Dependency Injection**: Use environment objects for shared state
- **Reactive Programming**: Combine framework for data flow
- **Service Layer**: Centralized business logic in dedicated services
- **Natural Language Automation**: Development workflows defined in plain English
- **AI-Native Architecture**: Machine-readable project structure for intelligent assistance

---

## MVVM Implementation

### ViewModel Template
```swift
import Foundation
import Combine

class ExampleViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var data: [DataModel] = []
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let apiService: APIServiceProtocol
    
    // MARK: - Initialization
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
        setupBindings()
    }
    
    // MARK: - Public Methods
    func loadData() {
        isLoading = true
        
        apiService.fetchData()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] data in
                    self?.data = data
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Setup reactive bindings here
    }
}
```

### ViewModel Best Practices
- Use `@Published` for properties that trigger UI updates
- Implement proper error handling with user-friendly messages
- Use weak self in closures to prevent retain cycles
- Centralize business logic in ViewModels, not in Views
- Use dependency injection for services (protocol-based)

---

## SwiftUI Best Practices

### View Structure
```swift
struct ExampleView: View {
    @EnvironmentObject private var viewModel: ExampleViewModel
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @State private var localState: Bool = false
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Title")
                .onAppear { viewModel.loadData() }
                .sheet(isPresented: $viewModel.showSheet) {
                    SheetContentView()
                }
        }
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            // Content here
        }
        .padding()
    }
}
```

### SwiftUI Guidelines
- Break large views into smaller, reusable components
- Use computed properties for complex view hierarchies
- Implement proper iPad responsiveness with `horizontalSizeClass`
- Use environment objects for shared state
- Handle loading and error states consistently
- Use `.task` for async operations, `.onAppear` for sync setup

### iPad Compatibility
```swift
// Responsive spacing and sizing
.padding(hSizeClass == .regular ? 24 : 16)

// Conditional image scaling
.aspectRatio(contentMode: hSizeClass == .regular ? .fit : .fill)

// Adaptive layout
if hSizeClass == .regular {
    HStack { /* iPad layout */ }
} else {
    VStack { /* iPhone layout */ }
}
```

---

## Environment Objects & Dependency Injection

### App Setup
```swift
@main
struct WhimziVoiceTalesSwiftApp: App {
    @StateObject private var voiceRecorder = VoiceRecorderViewModel()
    @StateObject private var appSettings = AppSettingsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(voiceRecorder)
                .environmentObject(appSettings)
        }
    }
}
```

### Service Injection Pattern
```swift
protocol APIServiceProtocol {
    func fetchData() -> AnyPublisher<[DataModel], Error>
}

class APIService: APIServiceProtocol {
    static let shared = APIService()
    // Implementation
}

// In ViewModel
init(apiService: APIServiceProtocol = APIService.shared) {
    self.apiService = apiService
}
```

---

## API Service Architecture

### Service Template
```swift
import Foundation
import Combine

class APIService: ObservableObject {
    static let shared = APIService()
    
    private let baseURL = "https://your-api.com/api"
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Request Methods
    func post<T: Codable>(
        endpoint: String,
        body: Data?,
        responseType: T.Type
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return Fail(error: APIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw APIError.serverError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: - Specific API Calls
    func generateStory(transcript: String, language: String, style: String) -> AnyPublisher<StoryResponse, Error> {
        let requestBody = StoryRequest(
            transcript: transcript,
            language: language,
            animationStyle: style
        )
        
        guard let bodyData = try? JSONEncoder().encode(requestBody) else {
            return Fail(error: APIError.encodingError)
                .eraseToAnyPublisher()
        }
        
        return post(endpoint: "generate-story", body: bodyData, responseType: StoryResponse.self)
    }
}

enum APIError: LocalizedError {
    case invalidURL, serverError, encodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .serverError: return "Server error occurred"
        case .encodingError: return "Failed to encode request"
        }
    }
}
```

### API Best Practices
- Use protocols for service abstraction
- Implement comprehensive error handling
- Use Combine for reactive API calls
- Centralize endpoint configuration
- Implement request/response logging for debugging
- Handle network timeouts and retries
- Use proper HTTP status code checking

---

## Data Persistence

### StorageManager Pattern
```swift
class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let fileManager = FileManager.default
    
    private enum Keys {
        static let stories = "saved_stories"
    }
    
    // MARK: - UserDefaults Operations
    func saveStories(_ stories: [Story]) {
        do {
            let data = try JSONEncoder().encode(stories)
            userDefaults.set(data, forKey: Keys.stories)
        } catch {
            print("Error saving stories: \(error)")
        }
    }
    
    func loadStories() -> [Story] {
        guard let data = userDefaults.data(forKey: Keys.stories) else { return [] }
        
        do {
            return try JSONDecoder().decode([Story].self, from: data)
        } catch {
            print("Error loading stories: \(error)")
            return []
        }
    }
    
    // MARK: - File Operations
    func saveFile(data: Data, filename: String) -> URL? {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let documentsPath = documentsPath else { return nil }
        
        let fileURL = documentsPath.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
}
```

### Data Persistence Guidelines
- Use UserDefaults for simple app settings
- Use FileManager for media files and documents
- Implement proper error handling for all I/O operations
- Use background queues for file operations
- Clean up temporary files appropriately
- Implement data migration strategies

---

## Error Handling

### Comprehensive Error System
```swift
enum AppError: LocalizedError, Identifiable {
    case networkError(String)
    case audioPermissionDenied
    case fileNotFound(String)
    case apiError(String)
    
    var id: String { localizedDescription }
    
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "Network Error: \(message)"
        case .audioPermissionDenied:
            return "Microphone access is required"
        case .fileNotFound(let filename):
            return "File not found: \(filename)"
        case .apiError(let message):
            return "API Error: \(message)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .audioPermissionDenied:
            return "Please enable microphone access in Settings"
        case .networkError:
            return "Check your internet connection and try again"
        default:
            return "Please try again later"
        }
    }
}

// In ViewModel
@Published var errorMessage: String?
@Published var showErrorAlert: Bool = false

func handleError(_ error: Error) {
    DispatchQueue.main.async {
        self.errorMessage = error.localizedDescription
        self.showErrorAlert = true
    }
}
```

### Error Handling Best Practices
- Create custom error types with meaningful messages
- Always handle errors on the main queue for UI updates
- Provide recovery suggestions to users
- Log errors appropriately for debugging
- Use alerts or inline error messages consistently
- Implement fallback mechanisms where possible

---

## Async/Await Implementation

### Modern Async Patterns
```swift
class ModernAPIService {
    func generateStory(transcript: String) async throws -> StoryResponse {
        guard let url = URL(string: "\(baseURL)/generate-story") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = StoryRequest(transcript: transcript)
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        return try JSONDecoder().decode(StoryResponse.self, from: data)
    }
}

// In ViewModel
func generateStory() {
    Task {
        do {
            isLoading = true
            let story = try await apiService.generateStory(transcript: transcript)
            await MainActor.run {
                self.currentStory = story
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.handleError(error)
                self.isLoading = false
            }
        }
    }
}
```

---

## Context Engineering & AI-Native Development
*Creating intelligent, self-describing codebases for optimal AI collaboration*

### Philosophy
Context Engineering + Axiom Protocol transforms traditional development by creating projects that are simultaneously human-readable and machine-interpretable. This enables AI assistants to understand your project's architecture, patterns, and intentions with unprecedented precision.

### Two-Pillar Approach

#### 1. Context Engineering (Human Instructions)
**Purpose**: Provide clear, comprehensive instructions TO an AI

**Implementation**: Enhanced CLAUDE.md structure
```markdown
# CLAUDE.md - Enhanced Context Engineering

## Project Identity & Vision
- App Name: WhimziVoiceTales 
- Purpose: AI-powered children's story generation from voice recordings
- Target Users: Parents and children ages 3-12
- Core Value: Transform simple voice recordings into magical illustrated stories

## Architecture Philosophy
- Pattern: MVVM with SwiftUI
- Reactive: Combine framework for data flow
- Dependencies: Environment Objects pattern
- Testing: Unit tests for ViewModels, UI tests for user flows

## Swift Development Guidelines
- Code Style: SwiftFormat with team configuration
- Linting: SwiftLint with custom rules
- Documentation: All public APIs documented
- Error Handling: Comprehensive with user-friendly messages

## AI Assistance Preferences
- Prioritize Apple HIG compliance
- Always consider iPad compatibility
- Implement proper accessibility
- Follow established patterns in existing codebase
- Suggest improvements when relevant

## Domain-Specific Context
- Voice recording: AVAudioEngine integration
- Story generation: OpenAI API with custom prompts
- Text-to-speech: Google Cloud TTS with fallback to AVSpeechSynthesizer
- Image generation: Backend API integration with CDN storage
- Monetization: StoreKit subscription model
```

#### 2. Axiom Protocol (Machine-Readable Architecture)
**Purpose**: Make codebase self-describing FOR an AI

**Implementation**: Structured metadata files

##### .axiom-manifest.yml
```yaml
# iOS Project Axiom Manifest
projectInfo:
  name: "WhimziVoiceTalesSwift"
  type: "iOS App"
  framework: "SwiftUI + Combine"
  architecture: "MVVM"
  language: "Swift 5.9"
  minIOSVersion: "18.4"
  deployment: "iPhone & iPad Universal"

architecture:
  pattern: "MVVM"
  dataFlow: "Combine Reactive"
  navigation: "SwiftUI NavigationStack"
  stateManagement: "Environment Objects"
  persistence: "UserDefaults + FileManager"
  networking: "URLSession + Combine"

modules:
  - name: "Views"
    type: "UI Layer"
    pattern: "SwiftUI Views"
    dependencies: ["ViewModels"]
    
  - name: "ViewModels"
    type: "Business Logic"
    pattern: "ObservableObject"
    dependencies: ["Services", "Models"]
    
  - name: "Services"
    type: "Data/API Layer"
    pattern: "Protocol-based"
    dependencies: ["Models"]
    
  - name: "Models"
    type: "Data Models"
    pattern: "Codable Structs"
    dependencies: []

contracts:
  - "ViewModels/VoiceRecorderViewModel.contract.yml"
  - "Services/WhimziAPIService.contract.yml"
  - "Views/ContentView.contract.yml"
```

##### Component Contracts
```yaml
# ViewModels/VoiceRecorderViewModel.contract.yml
component:
  name: "VoiceRecorderViewModel"
  type: "ViewModel"
  purpose: "Manages voice recording, transcription, and story generation workflow"
  
interface:
  published_properties:
    - name: "isRecording"
      type: "Bool"
      purpose: "Indicates if audio recording is active"
    - name: "currentStory"
      type: "Story?"
      purpose: "Generated story object"
    - name: "errorMessage"
      type: "String?"
      purpose: "User-friendly error messages"
      
  public_methods:
    - name: "startRecording()"
      purpose: "Begin voice capture"
      preconditions: ["Microphone permission granted"]
      
    - name: "stopRecording()"
      purpose: "End voice capture and trigger transcription"
      postconditions: ["Audio sent to backend for processing"]

dependencies:
  services: ["WhimziAPIService", "AudioService"]
  models: ["Story", "StoryFrame"]
  
patterns:
  - "Combine reactive programming"
  - "Error handling with Published properties"
  - "Dependency injection via initializer"
  - "Weak self references in closures"
```

### iOS-Specific Context Engineering Patterns

#### 1. SwiftUI Component Context
```swift
// Enhanced component documentation
struct ContentView: View {
    // AXIOM: Root view managing main app interface
    // PATTERN: SwiftUI + Environment Objects
    // RESPONSIVE: iPhone/iPad adaptive layout
    // ACCESSIBILITY: Full VoiceOver support
    
    @EnvironmentObject private var viewModel: VoiceRecorderViewModel
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    var body: some View {
        // AXIOM: Responsive design based on size class
        NavigationStack {
            content
                .navigationTitle("Magical Story Teller")
                .task { await viewModel.initializeServices() }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        // AXIOM: Conditional layout for device compatibility
        if hSizeClass == .regular {
            iPadLayout // AXIOM: iPad-optimized interface
        } else {
            iPhoneLayout // AXIOM: iPhone-optimized interface
        }
    }
}
```

#### 2. ViewModel Contract Pattern
```swift
// AXIOM-ENHANCED: ViewModel with explicit contracts
class ExampleViewModel: ObservableObject {
    // AXIOM CONTRACT: This ViewModel follows MVVM pattern
    // - Published properties trigger UI updates
    // - Business logic centralized here
    // - Services injected via initializer
    // - Error handling via Published errorMessage
    
    @Published var isLoading: Bool = false
    @Published var data: [DataModel] = []
    @Published var errorMessage: String?
    
    // AXIOM: Dependency injection pattern
    private let apiService: APIServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
}
```

### AI-Native Development Workflow

#### 1. Project Initialization
```bash
#!/bin/bash
# iOS Axiom Protocol Setup

# Create Axiom directory structure
mkdir -p .axiom/{meta,cache,contracts}
mkdir -p .claude/commands
mkdir -p scripts

# Generate iOS-specific manifest
cat > .axiom-manifest.yml << EOF
projectInfo:
  name: "${PROJECT_NAME}"
  type: "iOS App"
  framework: "SwiftUI"
  architecture: "MVVM"
EOF

# Enhanced CLAUDE.md for iOS
cat > CLAUDE.md << EOF
# ${PROJECT_NAME} - iOS Development Context

## Architecture
- Pattern: MVVM with SwiftUI
- State Management: Combine + Environment Objects
- Navigation: SwiftUI Navigation API

## Development Standards
- Swift Style Guide compliance
- Apple HIG adherence
- Accessibility first approach
- iPad compatibility required
EOF

echo "iOS Axiom Protocol initialized ✅"
```

#### 2. Continuous Context Updates
```python
#!/usr/bin/env python3
# scripts/update-ios-context.py

import os
import yaml
from pathlib import Path

def analyze_swift_files():
    """Scan Swift files and update Axiom contracts"""
    swift_files = Path('.').rglob('*.swift')
    
    for file in swift_files:
        if 'ViewModel' in file.name:
            generate_viewmodel_contract(file)
        elif 'View' in file.name and file.name != 'Preview':
            generate_view_contract(file)
        elif 'Service' in file.name:
            generate_service_contract(file)

def generate_viewmodel_contract(swift_file):
    """Generate contract for ViewModel"""
    content = swift_file.read_text()
    published_props = extract_published_properties(content)
    methods = extract_public_methods(content)
    
    contract = {
        'component': {
            'name': swift_file.stem,
            'type': 'ViewModel',
            'purpose': extract_purpose_comment(content)
        },
        'interface': {
            'published_properties': published_props,
            'public_methods': methods
        }
    }
    
    contract_path = f".axiom/contracts/{swift_file.stem}.contract.yml"
    with open(contract_path, 'w') as f:
        yaml.dump(contract, f)

if __name__ == "__main__":
    analyze_swift_files()
    print("iOS context contracts updated ✅")
```

### Benefits for iOS Development

#### 1. Enhanced AI Code Generation
```swift
// Before Context Engineering:
// AI generates generic SwiftUI view

// After Context Engineering:
// AI generates view following your exact patterns:

struct NewFeatureView: View {
    // AXIOM: Follows established ViewModel pattern
    @EnvironmentObject private var viewModel: NewFeatureViewModel
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("New Feature")
                .task { await viewModel.loadData() }
                .alert("Error", isPresented: $viewModel.showError) {
                    Button("OK") { viewModel.clearError() }
                } message: {
                    Text(viewModel.errorMessage ?? "")
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        // AXIOM: iPad-responsive design pattern
        if hSizeClass == .regular {
            iPadLayout
        } else {
            iPhoneLayout
        }
    }
}
```

#### 2. Intelligent Refactoring
```yaml
# AI can understand refactoring context:
refactoring_request: "Extract common navigation logic"

ai_understanding:
  current_pattern: "Each view implements navigation separately"
  project_architecture: "MVVM with Environment Objects"
  suggested_solution: "Create NavigationCoordinator service"
  impact_analysis: "Affects 12 view files, maintains existing patterns"
```

#### 3. Automated Documentation
```swift
// AI generates contextual documentation:

/// AXIOM-GENERATED: VoiceRecorderViewModel
/// 
/// **Purpose**: Manages the complete voice-to-story workflow
/// **Architecture**: MVVM pattern with Combine reactive programming
/// **Dependencies**: WhimziAPIService, AudioService, StorageManager
/// **Usage**: Injected via Environment Object in ContentView
/// 
/// **State Flow**:
/// 1. User taps record → startRecording()
/// 2. Audio captured → stopRecording()
/// 3. Transcription → generateStory()
/// 4. Story ready → display in StoryDisplayView
class VoiceRecorderViewModel: ObservableObject {
    // Implementation follows established patterns...
}
```

### Implementation Checklist

#### Phase 1: Foundation (Week 1)
- [ ] Initialize Axiom Protocol structure
- [ ] Create enhanced CLAUDE.md with iOS context
- [ ] Document core architecture patterns
- [ ] Establish component contract templates

#### Phase 2: Component Mapping (Week 2)
- [ ] Generate contracts for existing ViewModels
- [ ] Document Service layer patterns
- [ ] Map View hierarchy and navigation
- [ ] Catalog reusable components

#### Phase 3: AI Integration (Week 3)
- [ ] Test AI understanding with simple requests
- [ ] Refine contracts based on AI feedback
- [ ] Establish context update workflows
- [ ] Create validation scripts

#### Phase 4: Team Adoption (Week 4)
- [ ] Train team on context engineering
- [ ] Establish maintenance procedures
- [ ] Document benefits and ROI
- [ ] Plan expansion to other projects

---

## Natural Language Development Rules
*Inspired by claudecode-rule2hook for simplified workflow automation*

### Philosophy
Replace complex configuration files with natural language rules that automatically generate development workflows, git hooks, and automation scripts. This approach makes project standards accessible to all team members regardless of technical background.

### Rule Categories for iOS Development

#### 1. Code Quality Rules
```yaml
# Natural Language Rules
code_quality_rules:
  - "Format Swift files with SwiftFormat after editing"
  - "Run SwiftLint validation before committing"
  - "Update unit tests when ViewModels change"
  - "Check memory leaks when editing retain cycles"
  - "Validate accessibility when UI components change"

# Auto-Generated Hooks
generated_hooks:
  - trigger: "post-edit"
    condition: "*.swift"
    action: "swiftformat --config .swiftformat {file}"
  
  - trigger: "pre-commit"
    action: "swiftlint lint --strict"
    
  - trigger: "file-change"
    condition: "**/*ViewModel.swift"
    action: "xcodebuild test -scheme UnitTests -testPlan ViewModelTests"
```

#### 2. Architecture Validation Rules
```swift
// Architecture Rules in CLAUDE.md
let architectureRules = [
    "Ensure ViewModels conform to ObservableObject",
    "Validate dependency injection usage in initializers",
    "Check that Views don't contain business logic",
    "Verify proper error handling in API services",
    "Ensure thread safety in async operations"
]

// Generated Validation Scripts
struct ArchitectureValidator {
    static func validateViewModel(_ file: URL) -> [ValidationIssue] {
        // Auto-generated validation logic
        let content = try! String(contentsOf: file)
        var issues: [ValidationIssue] = []
        
        if !content.contains(": ObservableObject") {
            issues.append(.missingObservableObject)
        }
        
        return issues
    }
}
```

#### 3. Apple Compliance Rules
```yaml
apple_compliance_rules:
  - "Validate HIG compliance when updating UI components"
  - "Check accessibility guidelines after interface changes"
  - "Ensure App Store guidelines compliance before submission"
  - "Verify privacy policy links when collecting data"
  - "Test dynamic type support when adding text elements"

automated_checks:
  - name: "HIG Color Contrast Check"
    trigger: "UI component update"
    validation: "Ensure color contrast ratio >= 4.5:1"
    
  - name: "Accessibility Label Validation"
    trigger: "New UI element"
    validation: "All interactive elements have accessibility labels"
```

#### 4. Testing Automation Rules
```javascript
// Testing Rules Configuration
const testingRules = [
  "Run unit tests when business logic changes",
  "Execute UI tests when user flows are modified", 
  "Perform integration tests when API endpoints change",
  "Run accessibility tests when UI components update",
  "Execute performance tests when optimization code changes"
];

// Generated Test Automation
class TestAutomation {
  static generateTestSuite(changedFiles) {
    const testSuite = [];
    
    changedFiles.forEach(file => {
      if (file.includes('ViewModel')) {
        testSuite.push('UnitTestSuite');
      }
      if (file.includes('View')) {
        testSuite.push('UITestSuite');
      }
      if (file.includes('Service')) {
        testSuite.push('IntegrationTestSuite');
      }
    });
    
    return testSuite;
  }
}
```

### Implementation in CLAUDE.md

#### Enhanced CLAUDE.md Structure
```markdown
# CLAUDE.md - Enhanced with Natural Language Rules

## Development Rules (Natural Language)

### Swift Code Standards
- "Use SwiftFormat with our team configuration after editing Swift files"
- "Run SwiftLint with warning threshold before committing"
- "Ensure all public APIs have documentation comments"
- "Validate MVVM pattern compliance in ViewModels"

### UI/UX Standards  
- "Check Apple HIG compliance when updating interface elements"
- "Validate accessibility requirements after UI changes"
- "Ensure iPad compatibility when modifying layouts"
- "Test dynamic type support with all text elements"

### Testing Requirements
- "Run affected unit tests when business logic changes"
- "Execute UI tests when user interaction flows change"
- "Perform snapshot tests when visual components update"
- "Run performance benchmarks when optimization code changes"

### Git Workflow
- "Format commit messages with conventional commit standards"
- "Squash commits before merging feature branches"
- "Tag releases with semantic versioning"
- "Update CHANGELOG when merging to main branch"

## Auto-Generated Hook Configurations
<!-- These sections are automatically updated by rule2hook -->
[Generated hook configurations based on rules above]
```

### Rule Processing Engine

#### 1. Swift-Specific Rule Parser
```swift
struct SwiftRuleParser {
    static func parseRule(_ rule: String) -> Hook? {
        // Parse natural language into actionable hooks
        if rule.contains("Format Swift files") {
            return Hook(
                trigger: .postEdit,
                condition: "*.swift",
                action: .shell("swiftformat {file}")
            )
        }
        
        if rule.contains("Run SwiftLint") {
            return Hook(
                trigger: .preCommit,
                action: .shell("swiftlint lint --strict")
            )
        }
        
        return nil
    }
}
```

#### 2. Xcode Project Integration
```bash
#!/bin/bash
# Generated Script: validate_architecture.sh

# Rule: "Ensure ViewModels conform to ObservableObject"
find . -name "*ViewModel.swift" -exec grep -L "ObservableObject" {} \; | while read file; do
    echo "⚠️ $file missing ObservableObject conformance"
done

# Rule: "Check that Views don't contain business logic"
find . -name "*View.swift" -exec grep -l "URLSession\|API" {} \; | while read file; do
    echo "⚠️ $file contains business logic - move to ViewModel"
done
```

### Benefits for iOS Development

1. **Simplified Configuration**: No need to learn complex hook syntax
2. **Team Accessibility**: Non-technical team members can define rules
3. **Consistency**: Standardized rule patterns across projects
4. **Maintainability**: Rules are human-readable and easily updated
5. **Apple Compliance**: Built-in validation for Apple guidelines
6. **Quality Assurance**: Automated enforcement of best practices

### Example Rule Implementations

#### SwiftUI Development Rules
```yaml
swiftui_automation:
  rules:
    - "Preview all new SwiftUI components before committing"
    - "Validate state management patterns in @State and @Published properties"
    - "Check navigation flow consistency when adding new screens"
    - "Ensure proper memory management in @StateObject and @ObservedObject"
  
  generated_validations:
    - name: "SwiftUI Preview Check"
      script: "find . -name '*.swift' -exec grep -l 'struct.*View' {} \; | xargs grep -L 'PreviewProvider'"
    
    - name: "State Management Validation"
      script: "validate_swiftui_state_management.swift"
```

#### App Store Connect Automation
```javascript
// App Store Rules
const appStoreRules = [
  "Update build number when creating release candidates",
  "Generate screenshots when UI changes for App Store",
  "Validate metadata compliance before submission",
  "Check privacy policy links when data collection changes"
];

// Auto-generated App Store Connect integration
class AppStoreAutomation {
  static async processReleaseCandidate() {
    await incrementBuildNumber();
    await generateScreenshots();
    await validateMetadata();
    await submitForReview();
  }
}
```

---

## File Management

### Automated Git Integration
Add to CLAUDE.md:
```markdown
## File Management Rules
- All file saves/updates must automatically sync to GitHub
- Use git add, commit, and push after file operations
- Commit messages should be descriptive and include 🤖 Generated tag
- Always check git status before and after operations
```

### File Operation Template
```swift
func saveAndCommitFile(content: String, path: String, commitMessage: String) {
    // Save file
    try? content.write(to: URL(fileURLWithPath: path), atomically: true, encoding: .utf8)
    
    // Git operations (via bash commands)
    // git add .
    // git commit -m "commitMessage 🤖 Generated with Claude Code"
    // git push origin main
}
```

---

## Apple App Store Compliance

### Critical Requirements Checklist (App Store Review Guidelines)
- [ ] Privacy Policy URL in App Store Connect (required for all apps)
- [ ] COPPA compliance for Kids category apps (special requirements)
- [ ] Data collection disclosures in App Store listing
- [ ] Age rating accuracy based on content and data collection
- [ ] Content guidelines compliance (no objectionable material)
- [ ] In-app purchase configuration with proper metadata
- [ ] App Store Review Guidelines adherence (all sections)
- [ ] Data minimization principle implementation
- [ ] User consent for data collection (explicit, not manipulative)
- [ ] Alternative functionality when users decline permissions

### Enhanced Privacy Policy Requirements (Apple Compliance)
```html
<!DOCTYPE html>
<html>
<head>
    <title>Privacy Policy - [App Name]</title>
    <meta charset="UTF-8">
</head>
<body>
    <!-- Apple requires all these sections -->
    <section>
        <h2>Data We Collect</h2>
        <p>We only collect data relevant to core app functionality:</p>
        <ul>
            <li>Voice recordings (processed and deleted immediately)</li>
            <li>Language preferences (stored locally)</li>
            <li>App usage analytics (anonymous)</li>
        </ul>
    </section>

    <section>
        <h2>How We Collect Data</h2>
        <p>Data collection methods:</p>
        <ul>
            <li>Microphone access (with explicit permission)</li>
            <li>User preferences (direct input)</li>
            <li>App interactions (anonymous analytics)</li>
        </ul>
    </section>

    <section>
        <h2>How We Use Data</h2>
        <p>Data usage is limited to:</p>
        <ul>
            <li>Generating personalized stories</li>
            <li>Improving app functionality</li>
            <li>Providing customer support</li>
        </ul>
    </section>

    <section>
        <h2>Data Retention and Deletion</h2>
        <p>Data retention policies:</p>
        <ul>
            <li>Voice recordings: Processed immediately, then deleted</li>
            <li>Generated stories: Stored locally until user deletion</li>
            <li>Preferences: Retained until app uninstall or manual deletion</li>
        </ul>
    </section>

    <section>
        <h2>Children's Privacy (COPPA Compliance)</h2>
        <p>Special protections for users under 13:</p>
        <ul>
            <li>No personal information collection without parental consent</li>
            <li>No behavioral tracking or profiling</li>
            <li>No sharing of child data with third parties</li>
            <li>Parents can review, delete, or refuse further collection</li>
        </ul>
    </section>

    <section>
        <h2>Third-Party Services</h2>
        <p>We use these services with appropriate privacy safeguards:</p>
        <ul>
            <li>Google Cloud Text-to-Speech (voice synthesis only)</li>
            <li>OpenAI API (story generation, no data retention)</li>
            <li>Apple StoreKit (subscription management)</li>
        </ul>
    </section>

    <section>
        <h2>User Rights and Control</h2>
        <p>Users can:</p>
        <ul>
            <li>Access all collected data</li>
            <li>Delete any or all stored data</li>
            <li>Withdraw consent for data collection</li>
            <li>Use core features without data sharing</li>
        </ul>
    </section>

    <section>
        <h2>Contact Information</h2>
        <p>For privacy concerns: privacy@[yourdomain].com</p>
        <p>Last updated: [Date]</p>
    </section>
</body>
</html>
```

### App Store Connect Configuration (Enhanced)
#### Required Steps for Apple Approval:
1. **Age Rating Configuration**:
   - Set to 4+ for children's apps (most restrictive appropriate rating)
   - Answer rating questionnaire accurately
   - Account for any user-generated content

2. **Data Collection Disclosure**:
   - Complete Privacy section in App Store Connect
   - List all data types collected
   - Specify data usage purposes
   - Indicate data sharing practices

3. **Subscription Configuration** (if applicable):
   - Configure StoreKit Configuration file
   - Set appropriate subscription group
   - Provide clear pricing and terms
   - Include subscription management information

4. **Content Requirements**:
   - App screenshots for all required device sizes
   - App preview videos (recommended)
   - Accurate app description without prohibited content
   - Relevant keywords for discoverability

### App Store Review Guidelines Compliance Checklist
```swift
// MARK: - Compliance Validation
struct AppStoreComplianceChecker {
    // 1.1 Objectionable Content
    static func validateContentAppropriate() -> Bool {
        // Ensure no objectionable content in generated stories
        return true
    }
    
    // 1.2 User Generated Content
    static func moderateUserContent() {
        // Implement content moderation for voice recordings
        // Filter inappropriate content before processing
    }
    
    // 2.1 App Completeness
    static func validateAppCompleteness() -> Bool {
        // Ensure all advertised features work
        // No placeholder content or broken features
        return true
    }
    
    // 5.1.1 Privacy - Data Collection and Storage
    static func validateDataCollection() {
        // Ensure minimal data collection
        // Validate explicit user consent
        // Provide data deletion options
    }
    
    // 5.1.2 Privacy - Data Use and Sharing
    static func validateDataUsage() {
        // Use data only for stated purposes
        // No unauthorized sharing with third parties
        // Respect user consent choices
    }
    
    // 5.6 Developer Code of Conduct
    static func validateDeveloperConduct() {
        // No manipulation or deception
        // Honest representation of app functionality
        // Respect user privacy choices
    }
}

---

## GitHub Integration

### Repository Setup
```bash
# Initialize repository
git init
git remote add origin https://github.com/username/repo-name.git

# Standard .gitignore for iOS
echo "*.xcuserstate
.DS_Store
build/
DerivedData/" > .gitignore

# Commit and push
git add .
git commit -m "Initial commit 🤖"
git push -u origin main
```

### Automated Workflow
```yaml
# .github/workflows/ios.yml
name: iOS Build and Test
on: [push, pull_request]

jobs:
  build:
    runs-on: macos-latest
    steps:
    - uses: actions/checkout@v3
    - name: Build
      run: |
        xcodebuild -project WhimziVoiceTalesSwift.xcodeproj \
        -scheme WhimziVoiceTalesSwift \
        -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
        build
```

---

## Backend Deployment (Railway)

### Express.js Server Setup
```javascript
const express = require('express');
const path = require('path');
const app = express();

app.use(express.json());
app.use(express.static('public'));

// Privacy policy route
app.get('/privacy-policy', (req, res) => {
    const privacyPath = path.join(__dirname, 'public', 'privacy-policy.html');
    res.sendFile(privacyPath, (err) => {
        if (err) {
            console.error('Error serving privacy policy:', err);
            res.status(500).send('Privacy policy temporarily unavailable');
        }
    });
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

### Railway Deployment Process
1. Connect GitHub repository to Railway
2. Configure environment variables
3. Set up automatic deployments
4. Monitor deployment logs
5. Test deployed endpoints

---

## In-App Purchases

### StoreKit Configuration
```json
{
  "identifier" : "KG.WhimziVoiceTalesSwift.premium_monthly",
  "reference_name" : "Premium Monthly",
  "type" : "Subscription",
  "duration" : "P1M",
  "introductory_offer" : null,
  "localizations" : [
    {
      "description" : "Unlimited access to story generation",
      "display_name" : "Premium Monthly",
      "locale" : "en_US"
    }
  ],
  "price" : "0.99",
  "subscription_group_identifier" : "premium_group"
}
```

### Purchase Flow Implementation
```swift
import StoreKit

class PurchaseManager: ObservableObject {
    @Published var isPurchased = false
    private var product: Product?
    
    func loadProduct() async {
        do {
            let products = try await Product.products(for: ["premium_monthly"])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }
    
    func purchase() async {
        guard let product = product else { return }
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified = verification {
                    isPurchased = true
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
}
```

---

## Localization & Multicultural Support

### String Localization Setup
```swift
extension String {
    static func localized(_ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: args)
    }
}

// Usage
let message = String.localized("welcome.message", userName)
```

### Language Configuration
```swift
class AppSettingsViewModel: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            updateVoiceAndStyle()
            saveSettings()
        }
    }
    
    private let languageMapping: [String: (voiceName: String, animationStyle: String)] = [
        "English (US)": ("en-US-Standard-C", "Disney/Pixar 3D Animation"),
        "Spanish (Spain)": ("es-ES-Standard-A", "Spanish Animation"),
        // ... additional mappings
    ]
}
```

### Multicultural Best Practices
- Support 65+ languages with appropriate TTS voices
- Implement culturally appropriate animation styles
- Use proper language codes for API calls
- Test with various character sets and RTL languages
- Provide fallback mechanisms for unsupported languages

---

## Testing Strategy

### Unit Testing Template
```swift
import XCTest
@testable import WhimziVoiceTalesSwift

class ViewModelTests: XCTestCase {
    var viewModel: ExampleViewModel!
    var mockAPIService: MockAPIService!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        viewModel = ExampleViewModel(apiService: mockAPIService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
    }
    
    func testDataLoading() {
        // Given
        let expectedData = [DataModel(id: 1, name: "Test")]
        mockAPIService.mockData = expectedData
        
        // When
        viewModel.loadData()
        
        // Then
        XCTAssertEqual(viewModel.data, expectedData)
        XCTAssertFalse(viewModel.isLoading)
    }
}
```

### Testing Guidelines
- Write unit tests for all ViewModels
- Mock external dependencies (API services, etc.)
- Test error handling scenarios
- Use XCTest framework consistently
- Implement UI tests for critical user flows
- Test on both iPhone and iPad simulators

---

## Performance Optimization

### Memory Management
```swift
class PerformantViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    deinit {
        cancellables.removeAll()
        print("ViewModel deallocated")
    }
    
    func performHeavyOperation() {
        Task.detached(priority: .background) {
            // Heavy work on background thread
            let result = await self.processData()
            
            await MainActor.run {
                self.updateUI(with: result)
            }
        }
    }
}
```

### Performance Best Practices
- Use background threads for heavy operations
- Implement proper memory management
- Optimize image loading and caching
- Use lazy loading for large datasets
- Monitor memory usage during development
- Implement efficient data structures

---

## Privacy & Security

### Apple Security Framework Requirements
Following Apple's security guidelines: "Security must be consciously designed into your app or service from the very beginning"

### Security Checklist
- [ ] API keys stored securely (not in source code)
- [ ] User data encrypted at rest and in transit
- [ ] Network traffic uses HTTPS with certificate pinning
- [ ] Sensitive data cleared from memory after use
- [ ] App Transport Security (ATS) properly configured
- [ ] Keychain used for sensitive storage with appropriate accessibility levels
- [ ] Input validation for all external data sources
- [ ] Static analysis tools integrated in build process
- [ ] Regular security threat model updates

### Data Protection Guidelines (Apple Compliance)
```swift
// MARK: - Secure Data Storage
class SecureStorageManager {
    private let keychain = Keychain(service: "com.yourapp.secure")
    
    func storeSecureData(_ data: String, forKey key: String) throws {
        try keychain
            .accessibility(.whenUnlockedThisDeviceOnly)
            .set(data, key: key)
    }
    
    func retrieveSecureData(forKey key: String) -> String? {
        return try? keychain.get(key)
    }
    
    func clearSecureData() {
        try? keychain.removeAll()
    }
}

// MARK: - Data Encryption
import CryptoKit

class DataProtectionManager {
    func encryptData(_ data: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    func decryptData(_ encryptedData: Data, using key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
```

### Privacy Implementation (App Store Guidelines Compliant)
```swift
import LocalAuthentication
import AppTrackingTransparency

class SecurityManager {
    static let shared = SecurityManager()
    
    // MARK: - Biometric Authentication
    func authenticateUser() async -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthentication,
                localizedReason: "Access your stories securely"
            )
            return success
        } catch {
            return false
        }
    }
    
    // MARK: - Privacy Consent Management
    @MainActor
    func requestTrackingPermission() async -> Bool {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            return ATTrackingManager.trackingAuthorizationStatus == .authorized
        }
        
        let status = await ATTrackingManager.requestTrackingAuthorization()
        return status == .authorized
    }
}

// MARK: - Data Minimization Principle
class PrivacyCompliantDataManager {
    // Only collect data relevant to core functionality
    func collectMinimalUserData() -> UserProfile {
        return UserProfile(
            // Only essential data
            preferredLanguage: getUserLanguagePreference(),
            // Avoid collecting unnecessary personal information
            creationDate: Date()
        )
    }
    
    // Provide alternative functionality if users decline permissions
    func handlePermissionDenied() {
        // Offer limited functionality without data collection
        showLimitedFeatures()
    }
}
```

### Network Security Implementation
```swift
import Network
import Security

class SecureNetworkManager {
    // MARK: - Certificate Pinning
    func setupCertificatePinning() {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        // Implementation details for certificate pinning
    }
    
    // MARK: - Input Validation
    func validateAPIResponse<T: Codable>(_ data: Data, type: T.Type) throws -> T {
        // Validate all external data before processing
        guard !data.isEmpty else {
            throw SecurityError.invalidData
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw SecurityError.malformedData
        }
    }
}

// MARK: - URLSessionDelegate for Certificate Pinning
extension SecureNetworkManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Implement certificate pinning validation
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Validate against pinned certificates
        let isValid = validateServerTrust(serverTrust)
        if isValid {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    private func validateServerTrust(_ serverTrust: SecTrust) -> Bool {
        // Implementation for certificate validation
        return true // Simplified - implement actual validation
    }
}
```

### Apple Privacy Policy Requirements
```swift
// MARK: - Privacy Disclosure Implementation
struct PrivacyDisclosureManager {
    static let requiredDisclosures = [
        "What data is collected": "Voice recordings, language preferences",
        "How data is collected": "Through microphone with user permission",
        "Data usage": "Story generation and personalization only",
        "Data retention": "Stories stored locally, audio deleted after processing",
        "User control": "Users can delete stories and data anytime"
    ]
    
    static func presentPrivacyPolicy() {
        // Present privacy policy before data collection
        // Must be easily accessible and understandable
    }
    
    static func handleDataDeletion() {
        // Implement user's right to delete their data
        StorageManager.shared.clearAllUserData()
        SecureStorageManager().clearSecureData()
    }
}
```

### Children's Privacy Protection (COPPA Compliance)
```swift
// MARK: - COPPA Compliance for Kids Apps
class ChildrenPrivacyManager {
    // No data collection from children under 13 without parental consent
    func checkAgeRestrictions() -> Bool {
        // Implement age verification if required
        return true
    }
    
    func requestParentalConsent() {
        // Implement parental consent mechanism if collecting data from minors
    }
    
    // Minimal data collection for children's apps
    func collectChildSafeData() -> ChildSafeProfile {
        return ChildSafeProfile(
            // Only anonymous, non-personal data
            appUsageSession: UUID(),
            timestamp: Date()
        )
    }
}
```

### Security Error Handling
```swift
enum SecurityError: LocalizedError {
    case invalidData
    case malformedData
    case encryptionFailed
    case authenticationRequired
    case certificateValidationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data received"
        case .malformedData:
            return "Data format is incorrect"
        case .encryptionFailed:
            return "Failed to encrypt sensitive data"
        case .authenticationRequired:
            return "Authentication required to access this feature"
        case .certificateValidationFailed:
            return "Server certificate validation failed"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .authenticationRequired:
            return "Please authenticate using Face ID, Touch ID, or passcode"
        case .certificateValidationFailed:
            return "Check your internet connection and try again"
        default:
            return "Please try again or contact support if the problem persists"
        }
    }
}
```

---

## Summary

This comprehensive guide consolidates all best practices learned from the WhimziVoiceTales project, covering:

- **Architecture**: MVVM pattern with proper separation of concerns
- **Integration**: GitHub, Railway, and App Store Connect workflows
- **Compliance**: Apple guidelines and privacy requirements
- **Performance**: Memory management and optimization techniques
- **Localization**: Multi-language support with cultural considerations
- **Security**: Privacy protection and secure coding practices

Following these practices will ensure:
- Maintainable and scalable code architecture
- Seamless deployment and integration workflows
- Apple App Store approval compliance
- High-quality user experience across all devices
- Robust error handling and performance optimization

Use this guide as a reference for future Swift iOS development projects to maintain consistency and quality standards established in the WhimziVoiceTales project.