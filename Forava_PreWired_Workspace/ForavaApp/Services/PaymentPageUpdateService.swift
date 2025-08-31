import Foundation

// MARK: - Phase 3: Payment Page Update Service
// Updates kg191.github.io payment page per transformation strategy

@MainActor
class PaymentPageUpdateService {
    static let shared = PaymentPageUpdateService()

    private let terminologyService = DynamicCulturalTerminologyService.shared

    private init() {}

    // MARK: - Payment Page Content Generation

    func generateUpdatedPaymentPageHTML(
        senderName: String,
        occasion: String,
        amount: String? = nil
    ) -> String {
        let culturalOccasion = terminologyService.getCurrentOccasion()
        let occasionName = culturalOccasion?.displayName ?? "Special Occasion"

        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Digital \(occasionName) Gift - Forava</title>
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', sans-serif;
                    background: linear-gradient(135deg, #FF8A00, #FFC170);
                    margin: 0;
                    padding: 20px;
                    min-height: 100vh;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                }
                .container {
                    background: white;
                    border-radius: 20px;
                    padding: 40px;
                    max-width: 500px;
                    width: 100%;
                    box-shadow: 0 20px 40px rgba(0,0,0,0.15);
                    text-align: center;
                }
                .cultural-symbol {
                    font-size: 4em;
                    margin-bottom: 20px;
                }
                .sender-name {
                    color: #FF6A6A;
                    font-weight: bold;
                    font-size: 1.5em;
                    margin-bottom: 10px;
                }
                .gift-title {
                    color: #3E3A9F;
                    font-size: 1.8em;
                    font-weight: bold;
                    margin-bottom: 30px;
                }
                .message {
                    color: #1E1E24;
                    font-size: 1.1em;
                    line-height: 1.6;
                    margin-bottom: 40px;
                }
                .download-section {
                    background: #F8F9FB;
                    border-radius: 15px;
                    padding: 30px;
                    margin-top: 30px;
                }
                .download-title {
                    color: #3E3A9F;
                    font-weight: bold;
                    font-size: 1.3em;
                    margin-bottom: 15px;
                }
                .download-text {
                    color: #1E1E24;
                    margin-bottom: 25px;
                    line-height: 1.5;
                }
                .occasions-list {
                    color: #FF6A6A;
                    font-weight: 600;
                    margin-bottom: 25px;
                }
                .app-store-link {
                    display: inline-block;
                    background: #007AFF;
                    color: white;
                    padding: 12px 30px;
                    border-radius: 25px;
                    text-decoration: none;
                    font-weight: bold;
                    transition: all 0.3s ease;
                }
                .app-store-link:hover {
                    background: #0056CC;
                    transform: translateY(-2px);
                }
                .footer {
                    margin-top: 40px;
                    color: #999;
                    font-size: 0.9em;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="cultural-symbol">\(culturalOccasion?.symbol ?? "🎁")</div>

                <div class="sender-name">From: \(senderName)</div>

                <div class="gift-title">Digital \(occasionName) Gift</div>

                <div class="message">
                    \(getCulturalGreeting(for: occasion))
                </div>

                <div class="download-section">
                    <div class="download-title">Enjoyed receiving this greeting?</div>

                    <div class="download-text">
                        Pass it forward! Download Forava and create personalized AI-generated greetings for special occasions.
                    </div>

                    <div class="occasions-list">
                        Birthdays • Chinese New Year • Diwali • Christmas • Eid • Vesak • Rosh Hashanah • Raksha Bandhan
                    </div>

                    <a href="https://apps.apple.com/app/forava" class="app-store-link">
                        📱 Download Forava
                    </a>
                </div>

                <div class="footer">
                    Made with ❤️ for \(occasionName)
                </div>
            </div>

            <script>
                // Track page views for analytics
                console.log('Payment page viewed for \(occasion)');

                // Add smooth animations
                document.addEventListener('DOMContentLoaded', function() {
                    const container = document.querySelector('.container');
                    container.style.opacity = '0';
                    container.style.transform = 'translateY(20px)';

                    setTimeout(() => {
                        container.style.transition = 'all 0.8s ease';
                        container.style.opacity = '1';
                        container.style.transform = 'translateY(0)';
                    }, 100);
                });
            </script>
        </body>
        </html>
        """
    }

    // MARK: - Cultural Greetings

    private func getCulturalGreeting(for occasion: String) -> String {
        switch occasion.lowercased() {
        case "raksha_bandhan":
            return "A sacred bond of protection and love has been shared with you. May this Raksha Bandhan strengthen the bonds that matter most."
        case "diwali":
            return "May the festival of lights illuminate your path with joy, prosperity, and endless happiness. Happy Diwali!"
        case "chinese_new_year":
            return "Wishing you prosperity, good health, and boundless happiness in the new year. Gong Xi Fa Cai!"
        case "christmas":
            return "May the magic of Christmas fill your heart with wonder, joy, and the warmth of loved ones."
        case "eid":
            return "May this blessed celebration bring you peace, happiness, and spiritual fulfillment. Eid Mubarak!"
        case "vesak":
            return "May the teachings of Buddha guide you to inner peace and enlightenment. Happy Vesak Day!"
        case "rosh_hashanah":
            return "May this new year bring you health, happiness, and sweet moments. L'Shanah Tovah!"
        case "hanukkah":
            return "May the lights of Hanukkah brighten your home and fill your heart with joy for eight wonderful nights."
        case "holi":
            return "May the colors of Holi paint your life with happiness, love, and vibrant memories."
        case "mid_autumn_festival":
            return "May the full moon bring you reunion with loved ones and harmony in all your endeavors."
        case "easter":
            return "May this Easter bring you hope, renewal, and the joy of new beginnings."
        case "birthday":
            return "Celebrating another year of your wonderful life! May this special day bring you joy and beautiful memories."
        default:
            return "A special digital gift has been created just for you with love and care."
        }
    }

    // MARK: - Dynamic URL Generation

    func generatePaymentURL(
        senderName: String,
        occasion: String,
        amount: Double? = nil,
        recipientName: String? = nil
    ) -> String {
        var components = URLComponents(string: "https://kg191.github.io/payment")!

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "sender", value: senderName),
            URLQueryItem(name: "occasion", value: occasion)
        ]

        if let amount = amount {
            queryItems.append(URLQueryItem(name: "amount", value: String(format: "%.2f", amount)))
        }

        if let recipient = recipientName {
            queryItems.append(URLQueryItem(name: "recipient", value: recipient))
        }

        components.queryItems = queryItems

        return components.url?.absoluteString ?? "https://kg191.github.io/payment"
    }

    // MARK: - Payment Page Deployment Instructions

    func getDeploymentInstructions() -> String {
        return """
        PHASE 3 DEPLOYMENT INSTRUCTIONS:

        1. Update kg191.github.io repository with new payment page HTML
        2. Remove "Amount: AU$xxx" display from payment interface
        3. Implement dynamic sender name from URL parameters
        4. Update cultural messaging per occasion type
        5. Add cultural symbols and appropriate colors
        6. Update download messaging with comprehensive occasion list
        7. Test all cultural occasions for proper rendering

        FILES TO UPDATE:
        - index.html (main payment page)
        - style.css (cultural styling)
        - script.js (dynamic content loading)

        URL PARAMETERS:
        - sender: Actual sender name (replaces "Forava Creator")
        - occasion: Cultural occasion for dynamic content
        - amount: Optional amount (hidden from display)
        - recipient: Optional recipient name

        TESTING CHECKLIST:
        □ All 12 cultural occasions render correctly
        □ Sender name displays properly
        □ Amount field is removed
        □ Cultural greetings are appropriate
        □ Download messaging is updated
        □ Mobile responsiveness works
        □ Loading animations function
        """
    }
}

// MARK: - Payment Page Models

struct PaymentPageContent {
    let senderName: String
    let occasion: String
    let culturalSymbol: String
    let greeting: String
    let occasionName: String
    let primaryColor: String
    let secondaryColor: String
}

extension PaymentPageUpdateService {

    func generatePaymentPageContent(for occasion: String, senderName: String) -> PaymentPageContent {
        let culturalOccasion = DynamicCulturalTerminologyService.supportedOccasions.first { $0.id == occasion }

        return PaymentPageContent(
            senderName: senderName,
            occasion: occasion,
            culturalSymbol: culturalOccasion?.symbol ?? "🎁",
            greeting: getCulturalGreeting(for: occasion),
            occasionName: culturalOccasion?.displayName ?? "Special Occasion",
            primaryColor: "#FF8A00", // Forava orange
            secondaryColor: "#3E3A9F"  // Forava indigo
        )
    }
}
