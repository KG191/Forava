import Foundation

public enum MoneyFormat {
    public static func string(minor: Int64, currency: String, locale: Locale = .current) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency
        return formatter.string(from: NSNumber(value: Double(minor)/100.0)) ?? "\(currency) \(Double(minor)/100.0)"
    }
}
