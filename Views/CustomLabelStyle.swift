//
//  SwiftUIView.swift
//  DatePlanner
//
//  Created by Nikos Galinos on 31/5/23.
//

import SwiftUI

struct CustomLabelStyle: LabelStyle {
  @ScaledMetric private var iconWidth: Double = 40
  func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 0) {
      configuration.icon
        .imageScale(.large)
        .frame(width: iconWidth)
      configuration.title
    }
  }
}
