//
//  ContentView.swift
//  NeverForget
//
//  Created by Eric on 17/09/2025.
//

import EventKit
import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @State private var eventStore = EKEventStore()
    @State private var events = [EKEvent]()

    var body: some View {
        NavigationStack {
            List(events, id: \.eventIdentifier) { event in
                Button {
                    print("DEBUG: Toogle alarm for \(String(describing: event.title))")
                } label: {
                    HStack {
                        VStack (alignment: .leading) {
                            Text(event.title)
                            Text(event.startDate, format: .dateTime.month().day().hour().minute())
                        }
                    }
                }
            }
            .navigationTitle("NeverForget")
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                Task {
                    try await loadEvents()
                }
            }
        }
    }

    func loadEvents() async throws {
        guard try await eventStore.requestFullAccessToEvents() else { return }

        let endDate = Date.now.offsetBy(days: 90, seconds: 0)

        let predicate = eventStore.predicateForEvents(withStart: .now, end: endDate, calendars: nil)
        let rawEvents = eventStore.events(matching: predicate)

        let grouped = Dictionary(grouping: rawEvents, by: \.calendarItemIdentifier)

        let firstInstances = grouped.compactMap { _, events in
            events.min { $0.startDate < $1.startDate }
        }

        events = firstInstances.sorted { $0.startDate < $1.startDate }
    }
}

#Preview {
    ContentView()
}
