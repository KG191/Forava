import Foundation
import SwiftUI

// MARK: - Voucher Provider Model
struct VoucherProvider: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let category: VoucherCategory
    let url: URL
    let icon: String  // DEPRECATED: No longer used (using category.icon instead for IP compliance)
    let primaryColor: Color

    static func == (lhs: VoucherProvider, rhs: VoucherProvider) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Voucher Category
enum VoucherCategory: String, CaseIterable {
    case entertainment = "Entertainment"
    case beauty = "Beauty & Cosmetics"
    case departmentStore = "Department Stores"
    case books = "Books & Reading"
    case fashion = "Fashion & Apparel"
    case sports = "Sports & Fitness"
    case electronics = "Electronics"

    var icon: String {
        switch self {
        case .entertainment:
            return "ticket.fill"
        case .beauty:
            return "sparkles"
        case .departmentStore:
            return "building.2.fill"
        case .books:
            return "book.fill"
        case .fashion:
            return "tshirt.fill"
        case .sports:
            return "figure.run"
        case .electronics:
            return "laptopcomputer"
        }
    }

    var color: Color {
        switch self {
        case .entertainment:
            return Color(hex: "#FF6B6B")
        case .beauty:
            return Color(hex: "#FF8ED4")
        case .departmentStore:
            return Color(hex: "#4ECDC4")
        case .books:
            return Color(hex: "#95E1D3")
        case .fashion:
            return Color(hex: "#F38181")
        case .sports:
            return Color(hex: "#AA96DA")
        case .electronics:
            return Color(hex: "#5C7CFA")
        }
    }
}

// MARK: - Voucher Provider Defaults
extension VoucherProvider {
    static let allProviders: [VoucherProvider] = [
        // Entertainment
        VoucherProvider(
            name: "Ticketek",
            category: .entertainment,
            url: URL(string: "https://premier.ticketek.com.au/")!,
            icon: "ticketek",
            primaryColor: Color(hex: "#FF6B6B")
        ),
        VoucherProvider(
            name: "Event Cinema",
            category: .entertainment,
            url: URL(string: "https://www.eventcinemas.com.au/")!,
            icon: "event_cinemas",
            primaryColor: Color(hex: "#E84A5F")
        ),

        // Beauty & Cosmetics
        VoucherProvider(
            name: "Sephora",
            category: .beauty,
            url: URL(string: "https://www.sephora.com.au/")!,
            icon: "sephora",
            primaryColor: Color(hex: "#000000")
        ),
        VoucherProvider(
            name: "Mecca Maxima",
            category: .beauty,
            url: URL(string: "https://www.mecca.com.au/")!,
            icon: "mecca_maxima",
            primaryColor: Color(hex: "#FF8ED4")
        ),

        // Department Stores
        VoucherProvider(
            name: "Myer",
            category: .departmentStore,
            url: URL(string: "https://www.myer.com.au/")!,
            icon: "myer",
            primaryColor: Color(hex: "#D32F2F")
        ),
        VoucherProvider(
            name: "David Jones",
            category: .departmentStore,
            url: URL(string: "https://www.davidjones.com/")!,
            icon: "david_jones",
            primaryColor: Color(hex: "#1976D2")
        ),
        VoucherProvider(
            name: "Westfield",
            category: .departmentStore,
            url: URL(string: "https://www.westfieldgiftcards.com.au/Online/order/order-card?_gl=1*1y656me*_gcl_au*MzYyMDEzNTY4LjE3NjI2NDYzMzE.*_ga*MTA0Mjg1MzIzMS4xNzYyNjQ2MzMx*_ga_BTMN40XGDR*czE3NjI2NTgzODIkbzIkZzEkdDE3NjI2NTg4MzUkajU5JGwwJGgxMjUzNTM4Nzgy")!,
            icon: "westfield",
            primaryColor: Color(hex: "#E30613")
        ),

        // Books & Reading
        VoucherProvider(
            name: "Dymocks",
            category: .books,
            url: URL(string: "https://www.dymocks.com.au/")!,
            icon: "dymocks",
            primaryColor: Color(hex: "#388E3C")
        ),

        // Fashion & Apparel
        VoucherProvider(
            name: "Country Road",
            category: .fashion,
            url: URL(string: "https://www.countryroad.com.au/")!,
            icon: "country_road",
            primaryColor: Color(hex: "#5D4037")
        ),
        VoucherProvider(
            name: "Witchery",
            category: .fashion,
            url: URL(string: "https://www.witchery.com.au/")!,
            icon: "witchery",
            primaryColor: Color(hex: "#212121")
        ),
        VoucherProvider(
            name: "Mimco",
            category: .fashion,
            url: URL(string: "https://www.mimco.com.au/")!,
            icon: "mimco",
            primaryColor: Color(hex: "#F38181")
        ),

        // Sports & Fitness
        VoucherProvider(
            name: "Nike",
            category: .sports,
            url: URL(string: "https://www.nike.com.au/")!,
            icon: "nike",
            primaryColor: Color(hex: "#FF6B00")
        ),
        VoucherProvider(
            name: "Adidas",
            category: .sports,
            url: URL(string: "https://www.adidas.com.au/")!,
            icon: "adidas",
            primaryColor: Color(hex: "#000000")
        ),
        VoucherProvider(
            name: "Rebel",
            category: .sports,
            url: URL(string: "https://www.rebelsport.com.au/")!,
            icon: "rebel",
            primaryColor: Color(hex: "#FF0000")
        ),

        // Electronics
        VoucherProvider(
            name: "JB Hi-Fi",
            category: .electronics,
            url: URL(string: "https://www.jbhifi.com.au/")!,
            icon: "jb_hifi",
            primaryColor: Color(hex: "#000000")
        )
    ]

    static func providers(for category: VoucherCategory) -> [VoucherProvider] {
        allProviders.filter { $0.category == category }
    }
}
