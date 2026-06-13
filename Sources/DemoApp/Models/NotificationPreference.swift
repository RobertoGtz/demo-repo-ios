import Foundation

struct NotificationPreference: Codable, Identifiable {
    enum NotificationType: String, Codable {
        case marketing
        case updates
        case reminders
        case social
    }
    
    let id: UUID
    let type: NotificationType
    var isEnabled: Bool
    
    init(type: NotificationType, isEnabled: Bool = true) {
        self.id = UUID()
        self.type = type
        self.isEnabled = isEnabled
    }
    
    mutating func toggle() {
        isEnabled.toggle()
    }
}