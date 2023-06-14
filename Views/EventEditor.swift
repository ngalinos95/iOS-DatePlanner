//
//  EventEditor.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import SwiftUI

struct EventEditor: View {
    @Binding var event: Event
    @State var isNew = false
    
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusedTask: EventTask?
    @State private var isPickingSymbol = false

    var body: some View {
        List {
            HStack {
                Button {
                    isPickingSymbol.toggle()
                } label: {
                    Image(systemName: event.symbol)
                        .imageScale(.large)
                        .foregroundColor(Color(event.color))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 5)

                TextField("New Event", text: $event.title)
                    .font(.title2)
            }
            .padding(.top, 5)
            
            DatePicker("Date", selection: $event.date)
                .labelsHidden()
                .listRowSeparator(.hidden)
            
            Text("Tasks")
                .fontWeight(.bold)
            
            ForEach($event.tasks) { $item in
                TaskRow(task: $item, focusedTask: $focusedTask)
            }
            .onDelete(perform: { indexSet in
                event.tasks.remove(atOffsets: indexSet)
            })

            Button {
                let newTask = EventTask(text: "", isNew: true)
                event.tasks.append(newTask)
                focusedTask = newTask
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Task")
                }
            }
            .buttonStyle(.borderless)
        }

        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .sheet(isPresented: $isPickingSymbol) {
            SymbolPicker(event: $event)
        }
    }
}

struct EventEditor_Previews: PreviewProvider {
    static var previews: some View {
        EventEditor(event: .constant(Event()), isNew: true)
            .environmentObject(EventData())
    }
}
