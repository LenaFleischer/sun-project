//
//  CitiesFile.swift
//  sun_test
//
//  Created by Miranda Hunter on 2/14/23.
//

import Foundation


protocol CitiesSource {

    func loadCities() -> [String]
}

struct CitiesFile: CitiesSource {

    let location: URL

    init(location: URL) {
        self.location = location
    }

    /// Looks up for `cities` file in the main bundle
    init?() {
        guard let location = Bundle.main.url(forResource: "cities", withExtension: ".txt") else {
            assertionFailure("cities file is not in the main bundle")
            return nil
        }

        self.init(location: location)
    }

    func loadCities() -> [String] {
            do {
                let data = try Data(contentsOf: location)
                let string = String(data: data, encoding: .utf8)
                return string?.components(separatedBy: .newlines) ?? []
            }
            catch {
                return []
            }
        }
    }


actor CitiesCache {

    let source: CitiesSource

    init(source: CitiesSource) {
        self.source = source
    }

    var cities: [String] {
        if let cities = cachedCities {
            return cities
        }

        let cities = source.loadCities()
        cachedCities = cities

        return cities
    }

    private var cachedCities: [String]?
}

extension CitiesCache {

    func lookup(prefix: String) -> [String] {
        let lowercasedPrefix = prefix.lowercased()
        return cities.filter { $0.lowercased().hasPrefix(lowercasedPrefix) }
    }
}
