//
//  ContentView.swift
//  Examples
//
//  Created by Yanis Plumit on 21.11.2022.
//

import SwiftUI
import ViewOnTouch

struct ContentView: View {
    var body: some View {
        VStack {
            // static view
            ZStack {
                Color.gray.opacity(0.1)
                VStack {
                    testView
                }
            }
            
            // scroll view
            ScrollView {
                testView
            }
        }
    }
    
    var testView: some View {
        VStack {
            plane1View
            plane2View
            button1View
            button2View
        }.padding()
    }
    
    var plane1View: some View {
        Color.green
            .frame(width: 100, height: 100)
            .onTouch(type: .all,
                     perform: { location, event in
                switch event {
                case .started:
                    print("Started at \(location)")
                case .moved:
                    break
                    // print("Moved at \(location)")
                case .ended:
                    print("Ended at \(location)")
                case .firstTouch:
                    print("FirstTouch at \(location)")
                case .tapGesture:
                    print("TapGesture at \(location)")
                case .longGestureStarted:
                    print("LongGestureStarted at \(location)")
                case .longGestureMoved:
                    print("LongGestureMoved at \(location)")
                case .longGestureEnded:
                    print("LongGestureEnded at \(location)")
                default:
                    break
                }
            })
    }
    
    var plane2View: some View {
        Color.red
            .frame(width: 100, height: 100)
            .onTouch(type: .allWithoutGestures,
                     perform: { location, event in
                switch event {
                case .started:
                    print("Started at \(location)")
                case .moved:
                    break
                    // print("Moved at \(location)")
                case .ended:
                    print("Ended at \(location)")
                case .firstTouch:
                    print("FirstTouch at \(location)")
                case .tapGesture:
                    print("TapGesture at \(location)")
                case .longGestureStarted:
                    print("LongGestureStarted at \(location)")
                case .longGestureMoved:
                    print("LongGestureMoved at \(location)")
                case .longGestureEnded:
                    print("LongGestureEnded at \(location)")
                default:
                    break
                }
            })
            .onTapGesture {
                print("Action -> onTapGesture")
            }
            .onLongPressGesture {
                print("Action -> onLongPressGesture")
            }
    }
    
    var button1View: some View {
        Button(action: {
            print("Action1")
        }, label: {
            HStack {
                Spacer()
                Text("Button 1").padding()
                Spacer()
            }
            .onTouch(type: .allWithoutGestures,
                     perform: { location, event in
                switch event {
                case .started:
                    print("Started at \(location)")
                case .moved:
                    break
                    // print("Moved at \(location)")
                case .ended:
                    print("Ended at \(location)")
                case .firstTouch:
                    print("FirstTouch at \(location)")
                case .tapGesture:
                    print("TapGesture at \(location)")
                case .longGestureStarted:
                    print("LongGestureStarted at \(location)")
                case .longGestureMoved:
                    print("LongGestureMoved at \(location)")
                case .longGestureEnded:
                    print("LongGestureEnded at \(location)")
                default:
                    break
                }
            })
        })
        .buttonStyle(EmptyStyle())
        .background(
            Capsule()
                .foregroundColor(.yellow)
        )
    }
    
    var button2View: some View {
        Button(action: {
            print("Action2")
        }, label: {
            HStack {
                Spacer()
                Text("Button 2").padding()
                Spacer()
            }
        })
        .buttonStyle(EmptyStyle())
        .background(
            Capsule()
                .foregroundColor(.yellow)
        )
        .onTouch(type: .all,
                 perform: { location, event in
            switch event {
            case .started:
                print("Started at \(location)")
            case .moved:
                break
                // print("Moved at \(location)")
            case .ended:
                print("Ended at \(location)")
            case .firstTouch:
                print("FirstTouch at \(location)")
            case .tapGesture:
                print("TapGesture at \(location)")
            case .longGestureStarted:
                print("LongGestureStarted at \(location)")
            case .longGestureMoved:
                print("LongGestureMoved at \(location)")
            case .longGestureEnded:
                print("LongGestureEnded at \(location)")
            default:
                break
            }
        })
    }
}

struct EmptyStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
