//
//  LazySwipeAction.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 18/1/25.
//

import SwiftUI

// swiftlint:disable all
public extension View {
    
    @MainActor
    func lazySwipeActions(
        cornerRadius: CGFloat = 0,
        edge: HorizontalEdge = .trailing,
        allowsFullSwipe: Bool = true,
        buttonWidth: CGFloat = 60,
        @ActionBuilder actions: @escaping () -> [SwipeAction]
    ) -> some View {
        modifier(LazySwipeAction(cornerRadius: cornerRadius,
                                 edge: edge,
                                 allowsFullSwipe: allowsFullSwipe,
                                 buttonWidth: buttonWidth,
                                 actions: actions())
        )
    }
}

@MainActor
struct LazySwipeAction: ViewModifier {

    let cornerRadius: CGFloat
    let edge: HorizontalEdge
    let allowsFullSwipe: Bool
    let buttonWidth: CGFloat
    @ActionBuilder var actions: [SwipeAction]

    // View Properties
    @Environment(\.colorScheme) private var scheme
    
    // View Unique ID
    let viewID = "CONTENTVIEW"
    
    @State private var isEnabled: Bool = true
    @State private var scrollOffset: CGFloat = .zero
    
    init(cornerRadius: CGFloat = 0,
         edge: HorizontalEdge,
         allowsFullSwipe: Bool,
         buttonWidth: CGFloat = 100,
         actions: [SwipeAction]) {
        self.cornerRadius = cornerRadius
        self.edge = edge
        self.allowsFullSwipe = allowsFullSwipe
        self.buttonWidth = buttonWidth
        self.actions = actions
    }

    func body(content: Content) -> some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.init(degrees: edge == .leading ? -180 : 0))
                    /// To Take Full Available Space
                        .containerRelativeFrame(.horizontal)
                        .background(scheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    ActionButtons(buttonWidth: buttonWidth) {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID,
                                                 anchor: edge == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: edge == .leading ? 180 : 0))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    
    // Action Buttons
    @ViewBuilder
    func ActionButtons(
        buttonWidth: CGFloat = 100,
        resetPosition: @escaping () -> ()
    ) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * buttonWidth)
            .overlay(alignment: edge == .leading ? .leading: .trailing) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { button in
                        Button(action: {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.3))
                                button.action()
                                /// Optional
                                try? await Task.sleep(for: .seconds(0.05))
                                isEnabled = true
                            }
                        }, label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: buttonWidth)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        })
                        .frame(width: buttonWidth)
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.init(degrees: edge == .leading ? -180 : 0))
                    }
                }
            }
    }
    
    nonisolated
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return (minX > 0 ? -minX : 0)
    }
    
    var filteredActions: [SwipeAction] {
        return actions.filter({ $0.isEnabled })
    }
}

// Offset Key
struct OffsetKey: PreferenceKey {
    static let defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ScrollView(.vertical) {
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(0...5, id: \.self) { _ in
                Text("Wow")
                    .background(.green)
                    .frame(height: 40)
                    .lazySwipeActions(
                        cornerRadius: 6,
                                      edge: .trailing,
                                      allowsFullSwipe: true,
                                      buttonWidth: 80
                    ) {
                        SwipeAction(tint: .blue,
                                    icon: "star.fill",
                                    isEnabled: true) {
                            print("Bookmarked")
                        }
                        SwipeAction(tint: .red,
                                    icon: "star.fill",
                                    isEnabled: true) {
                            print("Bookmarked")
                        }
                    }
                
            }
        }
    }
}
// swiftlint:enable all
