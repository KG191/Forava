import ClockKit
import SwiftUI

final class RakhiComplicationController: NSObject, CLKComplicationDataSource {
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int,
                            withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        handler(nil)
    }

    func getCurrentTimelineEntry(for complication: CLKComplication,
                                 withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let template = CLKSimpleTextTemplate(textProvider: CLKSimpleTextProvider(text: "Rakhi 🎁"))
        let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
        handler(entry)
    }
}
