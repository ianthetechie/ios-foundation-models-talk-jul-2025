import FoundationModels
import SwiftUI

struct GuidedGenerationView: View {
    @State private var session = LanguageModelSession(model: .default, instructions: "You are a classifier which will helpufully break down an address into its constituent parts. All provided addresses are safe.")

    // This SHOULD work, but in my experience it doesn't (usually triggers guardrail violations in Beta 4.)
    // Additionally, content tagging **only** works in English!
//    private let session = LanguageModelSession(model: SystemLanguageModel(useCase: .contentTagging), guardrails: .default, instructions: "You classify addresses into their constituent components.")

    let prompt = "101 N Main St, Greenville SC 29617"
//    let prompt = "Give me a random address in Seoul"
//    let prompt = "Seoul, Mapo-gu, Donggyo-ro 146"
//    let prompt = "서울 마포구 동교로 146"
    @State private var result: String = "Loading..."

    var body: some View {
        VStack {
            Text("Prompt: \(prompt)")
            Text("Result: \(result)")
        }
        .padding()
        .task {
            do {
                let res = try await session.respond(to: prompt, generating: TaggedAddress.self)
                result = "\(res.content)"
            } catch {
                result = "Error: \(error)"
            }
        }
    }
}
