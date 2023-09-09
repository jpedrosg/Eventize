//
//  Copyright © JJG Tech, Inc. All rights reserved.
//


import FirebaseCore
import SwiftUI

@main
struct EventizeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
