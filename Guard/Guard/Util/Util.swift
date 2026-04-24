//
//  Util.swift
//  Guard
//
//  Created by Lance Mao on 2021/12/3.
//

import Foundation
import Security


public enum ErrorCode: Int {
    case netWork = 10001
    case config = 10002
    case login = 10003
    case jsonParse = 10004
    case socialLogin = 10005
    case socialBinding = 10006
    case webView = 10007

    public func errorMessage() -> String {
        switch self {
        case .netWork:
            return "Network error"
        case .config:
            return "Config not found"
        case .login:
            return "Login failed"
        case .jsonParse:
            return "Json parse failed"
        case .socialLogin:
            return "Social login failed"
        case .socialBinding:
            return "Social binding failed"
        case .webView:
            return "Webview error"
        }
    }
}

public class Util {

    public enum PasswordStrength {
        case weak
        case medium
        case strong
    }

    enum KeychainError: Error {
        case itemNotFound
        case duplicateItem
        case invalidItemFormat
        case unexpectedStatus(OSStatus)
    }

    private static let SERVICE_UUID: String = "service_uuid"

    public static var cookies: [HTTPCookie] = []

    public static var langHeader: String?

    public static func getDeviceID() -> String {
        let savedUUID = load()
        if (savedUUID == nil) {
            let uuid: String = NSUUID().uuidString
            try? save(uuid: uuid)
            return uuid
        } else {
            return savedUUID!
        }
    }

    public static func load() -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService as String: SERVICE_UUID as AnyObject,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        if (status != 0) {
            ALog.e(Util.self, "Try get uuid from keychain operation finished with status: \(status)")
        }
        if (result == nil) {
            return nil
        }

        let dic = result as! NSDictionary
        let uuidData = dic[kSecValueData] as! Data
        let uuid = String(data: uuidData, encoding: .utf8)!
        return uuid
    }

    public static func save(uuid: String) throws {
        let uuidData: Data? = uuid.data(using: String.Encoding.utf8)
        let query = [
            kSecValueData: uuidData!,
            kSecAttrService: SERVICE_UUID,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        let status = SecItemAdd(query as CFDictionary, nil)

        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }

    public static func remove() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: SERVICE_UUID,
        ] as CFDictionary

        SecItemDelete(query)
    }

    public static func encryptPassword(_ message: String) -> String {
        let data: Data = Data(base64Encoded: Authing.getPublicKey())!

        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue!] as CFDictionary
        }

        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            ALog.d(Util.self, error.debugDescription)
            return "error"
        }

        let plain = Data(message.utf8)
        guard let encrypted = SecKeyCreateEncryptedData(
            secKey,
            .rsaEncryptionPKCS1,
            plain as CFData,
            &error
        ) as Data? else {
            ALog.d(Util.self, error.debugDescription)
            return "error"
        }
        return encrypted.base64EncodedString()
    }


    public static func getLangHeader() -> String {
        var language = Locale.current.identifier

        if langHeader != nil {
            language = langHeader!
        }

        if language.contains("Hant") {
            return "zh-TW"
        } else if language.contains("zh") {
            return "zh-CN"
        } else if language.contains("ja") {
            return "ja-JP"
        } else {
            return "en-US"
        }
    }

    public static func isIp(_ str: String) -> Bool {
        let reg = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
        return str.range(of: reg, options: .regularExpression, range: nil, locale: nil) != nil
    }

    public static func getHost(_ config: Config) -> String {
        if Util.isIp(Authing.getHost()) {
            return Authing.getHost()
        } else {
            return config.requestHostname ?? "\(config.identifier ?? "core").\(Authing.getHost())"
        }
    }

    public static func isNull(_ s: String?) -> Bool {
        return s == nil || s?.count == 0 || s == "null"
    }

    public static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    public static func getQueryStringParameter(url: URL, param: String) -> String? {
        guard let url = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }

    public static func computePasswordSecurityLevel(password: String) -> PasswordStrength {
        let length = password.count
        if (length < 6) {
            return .weak
        }

        let hasEnglish = Validator.hasEnglish(password)
        let hasNumber = Validator.hasNumber(password)
        let hasSpecialChar = Validator.hasSpecialCharacter(password)
        if (hasEnglish && hasNumber && hasSpecialChar) {
            return .strong
        } else if ((hasEnglish && hasNumber) ||
                   (hasEnglish && hasSpecialChar) ||
                   (hasNumber && hasSpecialChar)) {
            return .medium
        } else {
            return .weak
        }
    }

    public static func stringEncodeToUInt8Array(_ string: String) -> [UInt8] {
        var base64Encoded = string.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        let remainder = base64Encoded.count % 4
        if remainder > 0 {
            base64Encoded = base64Encoded.padding(toLength: base64Encoded.count + 4 - remainder,
                                                  withPad: "=",
                                                  startingAt: 0)
        }

        var array:  [UInt8] = []
        if let decodedData = Data(base64Encoded: base64Encoded) {
            array = [UInt8](decodedData)
        }

        return array
    }

    /// Cross-platform machine identifier (e.g. "MacBookPro18,3", "iPhone14,2").
    /// Returns the simulator model identifier when running in the iOS simulator.
    public static func machineModel() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return "Simulator \(simulatorModelIdentifier)"
        }
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?
            .trimmingCharacters(in: .controlCharacters) ?? ""
    }
}
