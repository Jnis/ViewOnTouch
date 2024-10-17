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
            Button(action: {
                print("Action1")
            }, label: {
                HStack {
                    Spacer()
                    Text("Title 1").padding()
                    Spacer()
                }
                .onTouch(type: .allWithoutLongGesture,
                         perform: { location, event in
                    switch event {
                    case .started:
                        print("Started at \(location)")
                    case .moved:
                        print("Moved at \(location)")
                    case .ended:
                        print("Ended at \(location)")
                    case .tapGestureTouch:
                        print("TapGestureTouch at \(location)")
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
        }.padding()
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
