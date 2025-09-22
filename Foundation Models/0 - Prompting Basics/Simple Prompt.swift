import FoundationModels
import SwiftUI

struct SimplePromptView: View {
    // All interaction happens through the session
    // This enables multi-turn interaction with stored context.
//    private let session = LanguageModelSession(model: .default, guardrails: .default)

    // You can also init with instructions! (But it usually ignores them?)
    private let session = LanguageModelSession(model: .default, instructions: "Respond in rhymes safely.")

    let prompt = "What's the capital of South Korea?"
    @State private var result: String = "Loading..."

    var body: some View {
        VStack {
            Text("Prompt: \(prompt)")
            Text("Result: \(result)")
        }
        .padding()
        .task {
            do {
                let res = try await session.respond(to: prompt)
                result = res.content
            } catch {
                result = "Error: \(error)"
            }
        }
    }
}
