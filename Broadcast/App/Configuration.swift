//
//  Configuration.swift
//  Broadcast
//
//  Created by Piotr Suwara on 17/11/20.
//

import Foundation


// MARK: - Public

extension Configuration {
    static var versionString: String { castedValue(for: .versionString, as: String.self)! }
    static var buildString: String { castedValue(for: .buildString, as: String.self)! }
    static var apiServiceBaseURL: URL { URL(string: "A url")! }
}

// MARK: - Private

private enum ConfigKey: String, CaseIterable {
    case versionString = "CFBundleShortVersionString"
    case buildString = "CFBundleVersion"
    case apiServiceBaseURL = "APIServiceBaseURL"
}

class Configuration {

    private static func castedArray<T>(for key: BundledConfigKey) -> [T]? {
        guard let array = castedValue(for: key, as: [Any].self) else {
            return nil
        }
        let castedArray = array.compactMap { $0 as? T }
        return (array.count == castedArray.count) ? castedArray : nil
    }

    private static func castedDictionary<T>(for key: BundledConfigKey) -> [String: T]? {
        guard let dictionary = castedValue(for: key, as: [String: Any].self) else {
            return nil
        }
        let castedDictionary = dictionary.compactMapValues { $0 as? T }
        return (dictionary.count == castedDictionary.count) ? castedDictionary : nil
    }

    private static func castedValue<T>(for key: BundledConfigKey, as _: T.Type) -> T? {
        do {
            guard let anyValue = envSpecificInfo[key.rawValue] ?? appInfo[key.rawValue] else {
                throw Error.invalidKey
            }
            guard let castedValue = anyValue as? T else {
                throw Error.castingError
            }
            return castedValue
        } catch {
            Logger.error(topic: .other, message: "Error retrieving configuration: \(error)")
            return nil
        }
    }

    private static func castedURL(for key: BundledConfigKey) -> URL? {
        do {
            guard let anyValue = envSpecificInfo[key.rawValue] ?? appInfo[key.rawValue] else {
                throw Error.invalidKey
            }
            guard let castedValue = anyValue as? String, let url = URL(string: castedValue) else {
                throw Error.castingError
            }
            return url
        } catch {
            Logger.error(topic: .other, message: "Error retrieving configuration: \(error)")
            return nil
        }
    }

    private enum Error: Swift.Error {
        case castingError
        case invalidKey
    }
}

// MARK: - Info Plist Data

extension Configuration {

    private static var appInfo: [String: Any] {
        return Bundle.main.infoDictionary!
    }

    private static var envSpecificInfo: [String: Any] {
        guard
            let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path) as? [String: Any]
        else {
            Logger.error(topic: .other, message: "Failed to retrieve environment specific plist")
            return [:]
        }
        return dictionary
    }
}
