//
//  Codable+Extensions.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 5.09.2022.
//

import Foundation

extension Encodable {
    func asDictionary() -> Parameters {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(CodableDateFormatter.outgoingDateFormatter)
            let data = try encoder.encode(self)

            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] ?? [:]
        } catch {
            return [:]
        }
    }

    var jsonData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

    var jsonString: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func toJson() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}


class CodableDateFormatter {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return formatter
    }()

    static let outgoingDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
