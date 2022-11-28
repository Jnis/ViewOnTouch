# ViewOnTouch

Detect event and coordinates of touch on SwiftUI view 
Inspired by https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view

- supported events: 
  - started
  - moved
  - ended
  - tapGesture
  - longGestureStarted
  - longGestureMoved
  - longGestureEnded

Notes:
Be careful when you handle touches of view located on scroll view. Simple tap on view in this case triggers tapGesture event only.

# Installing
Swift Package Manager:
```
https://github.com/Jnis/ViewOnTouch.git
```

# Usage


``` swift
MyView()
    .onTouch(type: longGestureAction == nil ? .allWithoutLongGesture : .all,
             perform: { location, event in
                print("\(location) - \(event.rawValue)")
                switch event {
                case .started:
                    viewModel.isTouchHandling = true
                    viewModel.touchDown?(location)
                case .moved:
                    viewModel.touchMove?(location)
                case .ended:
                    viewModel.isTouchHandling = false
                    viewModel.touchUp?(location)
                case .tapGesture where !viewModel.isTouchHandling:
                    viewModel.touchDown?(location)
                    viewModel.touchUp?(location)
                    tapAction?()
                case .longGestureStarted:
                    longGestureAction?(location, .started)
                case .longGestureMoved:
                    longGestureAction?(location, .moved)
                case .longGestureEnded:
                    longGestureAction?(location, .ended)
                default:
                    break
                }
            })

```

# License 
MIT

