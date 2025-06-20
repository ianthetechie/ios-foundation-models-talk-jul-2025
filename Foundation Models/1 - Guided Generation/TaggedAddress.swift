import FoundationModels

// Generable macro lets you use a type for structured model output.
// Everything gets embedded in the context for the model session.
// Internally basically coerces the model into formatting its responses as JSON.
// I've seen some deserialization errors on occasion; it's not perfect, but it's really good.
@Generable
struct TaggedAddress {
    // Guide macro lets you tell the model about each field, using natural language!
    @Guide(description: "The house or building number.")
    let number: String?
    @Guide(description: "The street part of an address, not including the house or building number")
    let street: String?
    @Guide(description: "City, town, or similar component of an address")
    let city: String?
    @Guide(description: "District within a city (might be present in addresses for major cities)")
    let district: String?
    @Guide(description: "The state, province, or similar primary national subdivision")
    let state: String?
    @Guide(description: "ZIP or postal code")
    let postalCode: Int?
    // You can also generate numbers, booleans, arrays, and other generable types (can be recursive!)
    // NB: These are actually generated in order and can be streamed!
}
