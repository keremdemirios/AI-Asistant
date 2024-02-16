//
//  AI_Voice_AsistantApp.swift
//  AI Voice Asistant
//
//  Created by Kerem Demir on 16.02.2024.
//

import SwiftUI

@main
struct AI_Voice_AsistantApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(width: 400,height: 400)
            #endif
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        #elseif os(visionOS)
        .defaultSize(width: 0.4, height: 0.4, depth:0.0, in: .meters)
        .windowResizability(.contentSize)
        #endif
    }
}
