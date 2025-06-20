import StadiaMaps
import SwiftUI

@main
struct Foundation_ModelsApp: App {
    var body: some Scene {
        WindowGroup {
            ScrollView {
                SimplePromptView()
                GuidedGenerationView()
                TZToolView()
            }
        }
    }

    init() {
        // Get your own API key at https://docs.stadiamaps.com/authentication/#generating-and-revoking-api-keys
        // to run the tools temo
        let STADIA_API_KEY = "YOUR_STADIA_API_KEY_HERE"
        StadiaMapsAPI.customHeaders = ["Authorization": "Stadia-Auth \(STADIA_API_KEY)"]
    }
}
