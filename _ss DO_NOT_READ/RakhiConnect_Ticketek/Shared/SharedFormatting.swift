import Foundation

public enum MoneyFormat {
    public static func string(minor: Int64, currency: String, locale: Locale = .current) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currency
        return f.string(from: NSNumber(value: Double(minor)/100.0)) ?? "\(currency) \(Double(minor)/100.0)"
    }
}
