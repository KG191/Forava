import Foundation

public enum Constants {
    public static let apiBaseURL = URL(string: "http://127.0.0.1:5055")! // Mock backend for testing
    public static let defaultCurrency = "AUD"
    public static let defaultAmountPresetsMinor: [Int64] = [500, 1000, 2500, 5000]
}
