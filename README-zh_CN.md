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

[English](./README.md) | 简体中文

## 简介

Authing 在 Apple 平台上的无 UI 登录核心。

此仓库以 Swift Package 形式提供 Authing 登录 API 客户端（`AuthClient`、`OIDCClient`、
`UserManager` 等），可嵌入到 **macOS** 与 **iOS** 应用中。所有基于 UIKit 的 UI
组件（视图控制器、XIB、按钮、动画、资源目录、本地化）均已移除，使本库可作为
纯粹的网络 + 认证层，在任意宿主 UI 框架（AppKit、SwiftUI、UIKit、命令行等）
中使用。

`WebKit` 仍在内部用于读取 User-Agent 以及在登出时清理 Cookie —— 这两套 API
在 macOS 与 iOS 上均可用，因此调用方无需做平台适配。

如果您需要原版完整的 iOS UI 体验，请使用上游项目：
https://github.com/Authing/guard-ios。

## 安装

在 `Package.swift` 中添加依赖：

```swift
.package(url: "https://github.com/alvesmarcos/guard-ios.git", from: "2.2.0")
```

然后在 target 中依赖 `Guard` product：

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Guard", package: "guard-ios"),
    ]
)
```

## 密码处理

密码在发送到后端之前会使用 **RSA-PKCS1 v1.5** 在客户端加密，使用的公钥为
`Authing.DEFAULT_PUBLIC_KEY`。加密通过 Apple 原生的 `Security.framework`
（`SecKeyCreateEncryptedData(.rsaEncryptionPKCS1, …)`）实现 —— 与上游 Authing
iOS SDK 以及 SwiftyAuthing 的
[`Encryption.swift`](https://github.com/jiananMars/SwiftyAuthing/blob/ff300b16c5a4b435f339817083bb95a32d702a7c/SwiftyAuthing/common/Encryption.swift)
使用完全相同的算法、填充方式与报文格式，只是去掉了第三方 `SwCrypt` 依赖。

如果您使用的是私有部署的 Authing，并拥有自己的公钥，可以通过以下方式覆盖：

```swift
Authing.setOnPremiseInfo(host: "auth.example.com", publicKey: "<base64 RSA 公钥>")
```

`publicKey` 参数可选，默认为 `Authing.DEFAULT_PUBLIC_KEY`，因此只传 `host:`
的已有调用方式可继续使用。

> ⚠️ **`v2.1.0` 版本存在问题，请勿使用。** 该版本移除了 `Util.encryptPassword`
> 并开始以明文方式发送密码，任何兼容 Authing 的后端都会返回
> `Failed to decrypt the password using the RSA algorithm. Please check the
> request parameters.` 错误。请升级至 `v2.2.0+`，该版本已恢复原有的加密逻辑。

## 文档

[中文文档请移步至这里查看](https://docs.authing.cn/v2/reference/sdk-for-ios/)

> 注意：文档中涉及 UIKit 组件或 `AuthFlow` 界面的部分**不适用**于此 Fork。
> 本库仅提供无 UI 的网络 API；密码在传输前会使用 RSA-PKCS1 v1.5 加密，
> 与上游 Authing 的报文格式一致。

## 兼容性说明
- macOS 10.15+
- iOS 13.0+
- Swift 5.5+ / Xcode 13.4+

## 常见问题

如果需要在线技术支持，可访问 [官方论坛](https://forum.authing.cn/)。此仓库的 issue 仅用于上报 Bug 和提交新功能特性。

## 贡献

https://github.com/Authing/.github/blob/main/CONTRIBUTING.md

## 开源许可

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2019-present Authing

## 获取帮助

若在接入过程中有任何疑问，请添加我们资深 iOS 工程师微信：

<img width="120" src="./doc/images/jianan.png">
