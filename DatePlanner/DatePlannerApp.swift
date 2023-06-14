//
//  DatePlannerApp.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import SwiftUI


@main
struct DatePlannerApp: App {
    @StateObject private var eventData = EventData()
    
    var body: some Scene {
        WindowGroup {
            EventList(eventData: eventData)
                .task {
                    eventData.load()
                }
                .onChange(of: eventData.events) { _ in
                    eventData.save()
                }
        }
    }
}
