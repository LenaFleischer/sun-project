//
//  AutocompleteObject.swift
//  sun_test
//
//  Created by Miranda Hunter on 2/14/23.
//

import Foundation


@MainActor
final class AutocompleteObject: ObservableObject {

    let delay: TimeInterval = 0.3

    @Published var suggestions: [String] = []

    init() {
    }

    private let citiesCache = CitiesCache(source: CitiesFile()!)

    private var task: Task<Void, Never>?

    func autocomplete(_ text: String) {
        guard !text.isEmpty else {
            suggestions = []
            task?.cancel()
            return
        }

        task?.cancel()

        task = Task {
            await Task.sleep(UInt64(delay * 1_000_000_000.0))

            guard !Task.isCancelled else {
                return
            }

            let newSuggestions = await citiesCache.lookup(prefix: text)

            //if isSuggestion(in: suggestions, equalTo: text) {
                // Do not offer only one suggestion same as the input
                suggestions = []
            //} else {
                if(newSuggestions.count > 5){
                    suggestions = Array(newSuggestions[...4])
                } else {
                    suggestions = newSuggestions
                }
            //}
        }
    }

    private func isSuggestion(in suggestions: [String], equalTo text: String) -> Bool {
        guard let suggestion = suggestions.first, suggestions.count == 1 else {
            return false
        }

        return suggestion.lowercased() == text.lowercased()
    }
}
