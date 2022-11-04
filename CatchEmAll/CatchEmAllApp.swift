//
//  CatchEmAllApp.swift
//  CatchEmAll
//
//  Created by Richard Isaacs on 28.10.22.
//

import SwiftUI

@main
struct CatchEmAllApp: App {
    var body: some Scene {
        WindowGroup {
            CreatureListView()
            let _ = print("----- CatchEmAllApp: call CreatureListView")
        }
    }
}
