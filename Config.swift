import Foundation

enum Config {
    static let openAIApiKey: String = {
        guard let apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"] else {
            fatalError("OpenAI API Key not found in environment variables")
        }
        return apiKey
    }()
} 