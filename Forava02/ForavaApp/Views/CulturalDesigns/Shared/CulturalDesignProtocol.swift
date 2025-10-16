import SwiftUI
import Foundation

protocol CulturalDesignViewProtocol: View {
    associatedtype CulturalTheme
    associatedtype CulturalElement
    associatedtype CulturalColorPalette
    associatedtype CulturalPersonalTouch
    associatedtype StyleContent: View
    associatedtype ElementsContent: View
    associatedtype ColorContent: View
    associatedtype TouchContent: View
    associatedtype CreateContent: View
    associatedtype CheckContent: View
    associatedtype SendContent: View

    var selectedContact: Contact { get }
    var selectedEvent: CulturalEvent { get }
    var currentTab: GiftDesignTab { get set }

    var selectedTheme: CulturalTheme? { get set }
    var selectedElements: [CulturalElement] { get set }
    var selectedColorPalette: CulturalColorPalette? { get set }
    var selectedMessage: CulturalPersonalTouch? { get set }
    var personalMessage: String { get set }

    @ViewBuilder func styleContent() -> StyleContent
    @ViewBuilder func elementsContent() -> ElementsContent
    @ViewBuilder func colorContent() -> ColorContent
    @ViewBuilder func touchContent() -> TouchContent
    @ViewBuilder func createContent() -> CreateContent
    @ViewBuilder func checkContent() -> CheckContent
    @ViewBuilder func sendContent() -> SendContent
}

extension CulturalDesignViewProtocol {
    var culturalColor: Color {
        return selectedEvent.category.primaryColor
    }

    var culturalIcon: String {
        return selectedEvent.category.icon
    }

    var culturalTitle: String {
        return selectedEvent.selectionTitle
    }
}
