//
//  EventData.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import SwiftUI

class EventData: ObservableObject {
 
    @Published var events: [Event] = [
        Event(symbol: "gift.fill",
              color: Color.red.rgbaColor,
              title: "Maya's Birthday",
              tasks: [EventTask(text: "Guava kombucha"),
                      EventTask(text: "Paper cups and plates"),
                      EventTask(text: "Cheese plate"),
                      EventTask(text: "Party poppers"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 30)),
        Event(symbol: "theatermasks.fill",
              color: Color.yellow.rgbaColor,
              title: "Pagliacci",
              tasks: [EventTask(text: "Buy new tux"),
                      EventTask(text: "Get tickets"),
                      EventTask(text: "Book a flight for Carmen"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 22)),
        Event(symbol: "heart.text.square.fill",
              color: Color.indigo.rgbaColor,
              title: "Health Check-up",
              tasks: [EventTask(text: "Bring medical ID"),
                      EventTask(text: "Record heart rate data"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 4)),
        Event(symbol: "leaf.fill",
              color: Color.green.rgbaColor,
              title: "Camping Trip",
              tasks: [EventTask(text: "Find a sleeping bag"),
                      EventTask(text: "Bug spray"),
                      EventTask(text: "Paper towels"),
                      EventTask(text: "Food for 4 meals"),
                      EventTask(text: "Straw hat"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 36)),
        Event(symbol: "gamecontroller.fill",
              color: Color.cyan.rgbaColor,
              title: "Game Night",
              tasks: [EventTask(text: "Find a board game to bring"),
                      EventTask(text: "Bring a dessert to share"),
                     ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 2)),
        Event(symbol: "graduationcap.fill",
              color: Color.primary.rgbaColor,
              title: "First Day of School",
              tasks: [
                  EventTask(text: "Notebooks"),
                  EventTask(text: "Pencils"),
                  EventTask(text: "Binder"),
                  EventTask(text: "First day of school outfit"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 365)),
        Event(symbol: "book.fill",
              color: Color.purple.rgbaColor,
              title: "Book Launch",
              tasks: [
                  EventTask(text: "Finish first draft"),
                  EventTask(text: "Send draft to editor"),
                  EventTask(text: "Final read-through"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 365 * 2)),
        Event(symbol: "globe.americas.fill",
              color: Color.gray.rgbaColor,
              title: "WWDC",
              tasks: [
                  EventTask(text: "Watch Keynote"),
                  EventTask(text: "Watch What's new in SwiftUI"),
                  EventTask(text: "Go to DT developer labs"),
                  EventTask(text: "Learn about Create ML"),
              ],
              date: Date.from(month: 6, day: 7, year: 2021)),
        Event(symbol: "case.fill",
              color: Color.orange.rgbaColor,
              title: "Sayulita Trip",
              tasks: [
                  EventTask(text: "Buy plane tickets"),
                  EventTask(text: "Get a new bathing suit"),
                  EventTask(text: "Find a hotel room"),
              ],
              date: Date.roundedHoursFromNow(60 * 60 * 24 * 19)),
    ]
    /*#-code-walkthrough(4.events)*/
    
    func add(_ event: Event) {
        events.append(event)
    }
        
    func remove(_ event: Event) {
        events.removeAll { $0.id == event.id}
    }
    
    func sortedEvents(period: Period) -> Binding<[Event]> {
        Binding<[Event]>(
            get: {
                self.events
                    .filter { $0.period == period}
                    .sorted { $0.date < $1.date }
            },
            set: { events in
                for event in events {
                    if let index = self.events.firstIndex(where: { $0.id == event.id }) {
                        self.events[index] = event
                    }
                }
            }
        )
    }
   
    
    func getBindingToEvent(_ event: Event) -> Binding<Event>? {
        Binding<Event>(
            get: {
                guard let index = self.events.firstIndex(where: { $0.id == event.id }) else { return Event.delete }
                return self.events[index]
            },
            set: { event in
                guard let index = self.events.firstIndex(where: { $0.id == event.id }) else { return }
                self.events[index] = event
            }
        )
    }
   
    private static func getEventsFileURL() throws -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("events.data")
    }

    func load() {
        do {
            let fileURL = try EventData.getEventsFileURL()
         
            let data = try Data(contentsOf: fileURL)
          
            events = try JSONDecoder().decode([Event].self, from: data)
          
            print("Events loaded: \(events.count)")
        } catch {
        
            print("Failed to load from file. Backup data used")
        
        }
    }
    
    func save() {
        do {
            let fileURL = try EventData.getEventsFileURL()
            let data = try JSONEncoder().encode(events)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Events saved")
        } catch {
            print("Unable to save")
        }
    }
}

enum Period: String, CaseIterable, Identifiable {
    case nextSevenDays = "Next 7 Days"
    case nextThirtyDays = "Next 30 Days"
    case future = "Future"
    case past = "Past"
    
    var id: String { self.rawValue }
    var name: String { self.rawValue }
}

extension Date {
    static func from(month: Int, day: Int, year: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: dateComponents) {
            return date
        } else {
            return Date.now
        }
    }

    static func roundedHoursFromNow(_ hours: Double) -> Date {
        let exactDate = Date(timeIntervalSinceNow: hours)
        guard let hourRange = Calendar.current.dateInterval(of: .hour, for: exactDate) else {
            return exactDate
        }
        return hourRange.end
    }
}
