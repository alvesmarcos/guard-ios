//
//  Const.swift
//  Guard
//
//  Created by Lance Mao on 2021/12/3.
//

import Foundation

typealias AuthCallback = (Int, String?, UserInfo?) -> Void

public class Const: NSObject {

    public static let SDK_VERSION: String = (Bundle(identifier: "cn.authing.Guard")?.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "2.0.0"

    public static let NO_DEVICE_PERMISSION_DISABLED = 1577
    public static let NO_DEVICE_PERMISSION_SUSPENDED = 1578

    public static let EC_MFA_REQUIRED = 1636
    public static let EC_FIRST_TIME_LOGIN = 1639
    public static let EC_ONLY_BINDING_ACCOUNT = 1640
    public static let EC_BINDING_CREATE_ACCOUNT = 1641
    public static let EC_ENTER_VERIFICATION_CODE = 2000
    public static let EC_MULTIPLE_ACCOUNT = 2921
}
