//
//  TimeSlider.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI

struct TimeSlider: View {

    @Binding var value: Double
    @State var isEditing: Bool = false
    let minimumValue: Double
    let maximumValue: Double
    let canUpdateTime: Bool
    let onValueChanged: (Double) -> Void

    var body: some View {
        Slider(value: $value,
               in: minimumValue...maximumValue,
               onEditingChanged: { editing in
            isEditing = editing
        })
        .onAppear {
            UISlider.appearance().thumbTintColor = canUpdateTime ? .systemPink : .clear
            UISlider.appearance().minimumTrackTintColor = .systemPink
        }
        .onChange(of: value) {
            guard isEditing else { return }
            onValueChanged(value)
        }
        .foregroundColor(.pink)
    }
}
