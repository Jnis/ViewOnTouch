//
//  View+OnTouch.swift
//
//
//  Created by Yanis Plumit on 19.11.2022.
//

import Foundation
import SwiftUI

// The types of touches users want to be notified about
public struct OnTouchType: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let started = OnTouchType(rawValue: 1 << 0)
    public static let moved = OnTouchType(rawValue: 1 << 1)
    public static let ended = OnTouchType(rawValue: 1 << 2)
    public static let tapGesture = OnTouchType(rawValue: 1 << 3)
    public static let longGestureStarted = OnTouchType(rawValue: 1 << 4)
    public static let longGestureMoved = OnTouchType(rawValue: 1 << 5)
    public static let longGestureEnded = OnTouchType(rawValue: 1 << 6)
    public static let allWithoutLongGesture: OnTouchType = [.started, .moved, .ended, tapGesture]
    public static let all: OnTouchType = [.started, .moved, .ended, tapGesture, .longGestureStarted, .longGestureMoved, .longGestureEnded]
}

// A new method on View that makes it easier to apply our touch locater view.
extension View {
    public func onTouch(type: OnTouchType, limitToBounds: Bool = false, perform: @escaping (CGPoint, OnTouchType) -> Void) -> some View {
        self.modifier(TouchLocaterModifier(type: type, limitToBounds: limitToBounds, perform: perform))
    }
}

// A custom SwiftUI view modifier that overlays a view with our UIView subclass.
struct TouchLocaterModifier: ViewModifier {
    var type: OnTouchType = .all
    var limitToBounds = true
    let perform: (CGPoint, OnTouchType) -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                TouchLocatingView(onUpdate: perform, types: type, limitToBounds: limitToBounds)
            )
    }
}

struct TouchLocatingView: UIViewRepresentable {
    // A closure to call when touch data has arrived
    var onUpdate: (CGPoint, OnTouchType) -> Void

    // The list of touch types to be notified of
    var types = OnTouchType.all

    // Whether touch information should continue after the user's finger has left the view
    var limitToBounds = true

    func makeUIView(context: Context) -> TouchLocatingUIView {
        // Create the underlying UIView, passing in our configuration
        let view = TouchLocatingUIView()
        view.onUpdate = onUpdate
        view.touchTypes = types
        view.limitToBounds = limitToBounds
        return view
    }

    func updateUIView(_ uiView: TouchLocatingUIView, context: Context) {
    }

    // The internal UIView responsible for catching taps
    class TouchLocatingUIView: UIView {
        // Internal copies of our settings
        var onUpdate: ((CGPoint, OnTouchType) -> Void)?
        var limitToBounds = true
        var touchTypes: OnTouchType = .all {
            didSet {
                tapGesture.isEnabled = touchTypes.contains(.tapGesture)
                longPressGesture.isEnabled = touchTypes.contains(.longGestureStarted) || touchTypes.contains(.longGestureMoved) || touchTypes.contains(.longGestureEnded)
            }
        }
        
        // Our main initializer, making sure interaction is enabled.
        override init(frame: CGRect) {
            super.init(frame: frame)
            customInit()
        }
        
        // Just in case you're using storyboards!
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            customInit()
        }
        
        private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        private lazy var longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(gesture:)))
        
        private func customInit() {
            isUserInteractionEnabled = true
            self.addGestureRecognizer(tapGesture)
            self.addGestureRecognizer(longPressGesture)
        }

        @objc private func tapGestureAction(gesture: UIGestureRecognizer) {
            let location = gesture.location(in: self)
            send(location, forEvent: .tapGesture)
        }
        
        @objc private func longPressGestureAction(gesture: UILongPressGestureRecognizer) {
            let location = gesture.location(in: self)
            if gesture.state == .began {
                send(location, forEvent: .longGestureStarted)
            } else if gesture.state == .changed {
                send(location, forEvent: .longGestureMoved)
            } else {
                send(location, forEvent: .longGestureEnded)
            }
        }
        
        // Triggered when a touch starts.
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .started)
        }

        // Triggered when an existing touch moves.
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesMoved(touches, with: event)
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .moved)
        }

        // Triggered when the user lifts a finger.
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Triggered when the user's touch is interrupted, e.g. by a low battery alert.
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Send a touch location only if the user asked for it
        func send(_ location: CGPoint, forEvent event: OnTouchType) {
            guard touchTypes.contains(event) else {
                return
            }

            if limitToBounds == false || bounds.contains(location) {
                onUpdate?(CGPoint(x: round(location.x), y: round(location.y)), event)
            }
        }
    }
}
