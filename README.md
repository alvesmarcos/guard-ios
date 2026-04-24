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
.package(url: "https://github.com/alvesmarcos/guard-ios.git", from: "2.1.0")
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

Starting with **v2.1.0** this fork sends passwords to the configured backend
as plaintext over TLS. The original RSA-with-public-key client-side
encryption (`Util.encryptPassword`, `Authing.DEFAULT_PUBLIC_KEY`,
`Authing.getPublicKey()`) has been removed because the upstream Authing
backend was the only consumer that knew how to decrypt that ciphertext.

As a result, this SDK is **not** compatible with `core.authing.cn`'s
password endpoints anymore — point it at a backend that accepts plaintext
passwords over HTTPS (and does its own hashing / KDF server-side), or fork
this repo and re-add the encryption helper.

## Documentation

[Click me for English documentation](https://docs.authing.cn/v2/en/reference/sdk-for-ios/)

> Note: documentation that references UIKit components, the `AuthFlow`
> screens, or client-side password encryption does **not** apply to this
> fork. Only the headless network APIs are available, and password fields
> are sent as plaintext over TLS.

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
