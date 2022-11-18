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
                if event == .started {
                    viewModel.isTouchHandling = true
                    viewModel.touchDown?(location)
                } else if event == .moved {
                    viewModel.touchMove?(location)
                } else if event == .ended {
                    viewModel.isTouchHandling = false
                    viewModel.touchUp?(location)
                } else if event == .tapGesture && !viewModel.isTouchHandling {
                    viewModel.touchDown?(location)
                    viewModel.touchUp?(location)
                    tapAction?()
                } else if event == .longGestureStarted {
                    longGestureAction?(location, .started)
                } else if event == .longGestureMoved {
                    longGestureAction?(location, .moved)
                } else if event == .longGestureEnded {
                    longGestureAction?(location, .ended)
                }
            })

```

# License 
MIT

