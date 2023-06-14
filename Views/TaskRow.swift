//
//  SwiftUIView.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import SwiftUI

struct TaskRow: View {
    @Binding var task: EventTask
    var focusedTask: FocusState<EventTask?>.Binding

    var body: some View {
        HStack {
            Button {
                task.isCompleted.toggle()
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)

            TextField("Task Description", text: $task.text)
                .focused(focusedTask, equals: task)
            Spacer()
        }
    }
}
