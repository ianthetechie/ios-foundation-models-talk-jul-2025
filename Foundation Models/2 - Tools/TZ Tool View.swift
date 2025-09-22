import FoundationModels
import StadiaMaps
import SwiftUI

struct TZToolView: View {
    // If you don't enable tools, the model can't answer most questions about time or location.
    @State private var session = LanguageModelSession(model: .default, tools: [CoarseGeocode(), GetCurrentTime()], instructions: "Use tools to search for location coordinates and get the current time info.")

    let prompt = "What time is it in Tallinn?"
//    let prompt = "Is Estonia observing daylight saving / summer time?"
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

struct GetCurrentTime: Tool {
    // Apple recommends concise descriptions (~1 sentence) due to context limits
    let description = "Find the time and UTC offsets at any point on earth."

    @Generable
    struct Arguments {
        @Guide(description: "The latitude coordinate")
        let latitude: Double
        @Guide(description: "The longitude coordinate")
        let longitude: Double
    }

    // Sadly, Dates don't conform to the required protocol,
    // so we return strings.
    func call(arguments: Arguments) async throws -> String {
        do {
            let res = try await GeospatialAPI.tzLookup(lat: arguments.latitude, lng: arguments.longitude)

            let dstOffset = if res.dstOffset != 0 {
                "The effective offset for DST/summer time is \(res.dstOffset)"
            } else {
                "No special offsets are in effect."
            }

            return "The current time is \(res.localRfc2822Timestamp). \(dstOffset)"
        } catch StadiaMaps.ErrorResponse.error(let code, _, _, _) where code == 401 {
            return "You need to configure a Stadia Maps API key in Foundation_ModelsApp.swift"
        }
    }
}

struct CoarseGeocode: Tool {
    let description = "Looks up coordinates for countries, cities, states, etc."

    @Generable
    struct Arguments {
        @Guide(description: "The name of the place (country, city, state, etc.)")
        let query: String
    }

    func call(arguments: Arguments) async throws -> String {
        do {
            let res = try await GeocodingAPI.searchV2(text: arguments.query, layers: [.coarse])

            return res.features.compactMap { feature in
                guard let point = feature.geometry else {
                    return nil
                }
                return "\(feature.properties.name)\n\tlat: \(point.coordinates[1]), lon: \(point.coordinates[0])"
            }.joined(separator: "\n===\n")
        } catch StadiaMaps.ErrorResponse.error(let code, _, _, _) where code == 401 {
            return "You need to configure a Stadia Maps API key in Foundation_ModelsApp.swift"
        }
    }
}
