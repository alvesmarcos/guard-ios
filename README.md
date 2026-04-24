# Guard (Apple Core)

<div align=center>
  <img width="250" src="https://files.authing.co/authing-console/authing-logo-new-20210924.svg" />
</div>
<br/>
<div align="center">
  <a href="https://forum.authing.cn/" target="_blank"><img src="https://img.shields.io/badge/chat-forum-blue" /></a>
  <a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/License-MIT-success" alt="License"></a>
  <a href="javascript:;"><img src="https://img.shields.io/badge/PRs-welcome-green"></a>
  <a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/swift-5.5-orange.svg?style=flat"></a>
<br/>
</div>

English | [简体中文](./README-zh_CN.md)

## Introduction

Headless Authing authentication core for Apple platforms.

This repository contains the Authing sign-in API client (`AuthClient`, `OIDCClient`,
`UserManager`, etc.) packaged as a Swift Package that can be embedded in
**macOS** and **iOS** applications. All UIKit-based UI (view controllers, XIBs,
buttons, animators, asset catalogs, localizations) has been removed so the
library can be used as a pure networking + auth layer regardless of the host
UI framework (AppKit, SwiftUI, UIKit, command-line, etc.).

`WebKit` is still used internally for user-agent retrieval and cookie cleanup
during logout — both APIs are available on macOS and iOS, so no platform shim
is required at the call site.

If you need the original full UI experience for iOS, check the upstream
project: https://github.com/Authing/guard-ios.

## Installation

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/alvesmarcos/guard-ios.git", from: "2.2.0")
```

then depend on the `Guard` product from your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Guard", package: "guard-ios"),
    ]
)
```

## Password handling

Passwords are encrypted client-side with **RSA-PKCS1 v1.5** before being
sent to the backend, using `Authing.DEFAULT_PUBLIC_KEY`. The encryption is
implemented natively via Apple's `Security.framework`
(`SecKeyCreateEncryptedData(.rsaEncryptionPKCS1, …)`) — same algorithm,
padding and wire format as the upstream Authing iOS SDK and as
SwiftyAuthing's
[`Encryption.swift`](https://github.com/jiananMars/SwiftyAuthing/blob/ff300b16c5a4b435f339817083bb95a32d702a7c/SwiftyAuthing/common/Encryption.swift),
just without the third-party `SwCrypt` dependency.

If you point the SDK at an on-premises Authing deployment with its own
public key, override it via:

```swift
Authing.setOnPremiseInfo(host: "auth.example.com", publicKey: "<base64 RSA public key>")
```

`publicKey` is optional and defaults to `Authing.DEFAULT_PUBLIC_KEY`, so
existing call sites that only pass `host:` keep working.

> ⚠️ **`v2.1.0` is broken — do not use.** It removed `Util.encryptPassword`
> and started sending plaintext passwords, which any Authing-compatible
> backend rejects with `Failed to decrypt the password using the RSA
> algorithm. Please check the request parameters.` Upgrade to `v2.2.0+`,
> which restores the original encryption.

## Documentation

[Click me for English documentation](https://docs.authing.cn/v2/en/reference/sdk-for-ios/)

> Note: documentation that references UIKit components or the `AuthFlow`
> screens does **not** apply to this fork. Only the headless network APIs
> are available; password fields are encrypted with RSA-PKCS1 v1.5 before
> transit, matching the upstream Authing wire format.

## Compatibility Notes
- macOS 10.15+
- iOS 13.0+
- Swift 5.5+ / Xcode 13.4+

## Questions

For questions and support please use the [official forum](https://forum.authing.cn/). The issue list of this repo is exclusively for bug reports and feature requests.

## Contribute

https://github.com/Authing/.github/blob/main/CONTRIBUTING.md

## License

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2019-present Authing

## Get help

Contact our senior iOS developer via Wechat:

<img width="120" src="./doc/images/jianan.png">
