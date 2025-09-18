//
//  EKEevent-UUID.swift
//  NeverForget
//
//  Created by Eric on 18/09/2025.
//

import EventKit
import Foundation

extension EKEvent {
    var neverForgetID: UUID {
        UUID(uuidString: self.calendarItemIdentifier) ?? UUID()
    }
}
