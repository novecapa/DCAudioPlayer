//
//  SearchBarView.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import SwiftUI

struct SearchBarView: View {

    enum Constants {
        static let searchIcon = "magnifyingglass"
        static let closeIcon = "xmark.circle.fill"
        static let frameSize: CGFloat = 40
        static let paddingH: CGFloat = 10
        static let cornerRadius: CGFloat = 10
        static let backgroundColor: Color = .gray.opacity(0.2)
    }

    @Binding var searchText: String
    var placeHolder: String

    var body: some View {
        RoundedRectangle(cornerRadius: Constants.cornerRadius)
            .fill(Constants.backgroundColor)
            .frame(height: Constants.frameSize)
            .padding(.horizontal, Constants.paddingH)
            .overlay(
                HStack {
                    Image(systemName: Constants.searchIcon)
                        .frame(alignment: .leading)
                        .padding(.leading)
                        .foregroundColor(.gray)
                    TextField(placeHolder,
                              text: $searchText)
                        .font(.callout)
                        .tint(.pink)
                        .foregroundColor(.black)
                    if !searchText.isEmpty {
                        Image(systemName: Constants.closeIcon)
                            .frame(alignment: .trailing)
                            .padding(.trailing)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                searchText = ""
                            }
                    }
                }.padding(.horizontal)
            )
    }
}
