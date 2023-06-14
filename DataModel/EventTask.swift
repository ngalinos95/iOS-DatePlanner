//
//  EventTask.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import Foundation

struct EventTask: Identifiable, Hashable, Codable {
  
    var id = UUID()
    var text: String
    var isCompleted = false
    var isNew = false
   
}
