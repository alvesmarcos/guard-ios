# Guard iOS

<div align=center>
  <img width="250" src="https://files.authing.co/authing-console/authing-logo-new-20210924.svg" />
</div>
<br/>
<div align="center">
  <a href="https://forum.authing.cn/" target="_blank"><img src="https://img.shields.io/badge/chat-forum-blue" /></a>
  <a href="https://opensource.org/licenses/MIT" target="_blank"><img src="https://img.shields.io/badge/License-MIT-success" alt="License"></a>
  <a href="javascript:;"><img src="https://img.shields.io/badge/PRs-welcome-green"></a>
  <a href="https://developer.apple.com/swift/"><img src="https://img.shields.io/badge/swift-5.0-orange.svg?style=flat"></a>
<br/>

</div>

<br>

[English](./README.md) | 简体中文

<img width="250" src="https://user-images.githubusercontent.com/10389329/182366962-6a93c2d2-de2c-4f4f-a144-6fb9d827ce2d.png" />

## 简介

Authing 在 Apple 平台（macOS / iOS）的无 UI 登录核心。

此仓库以 Swift Package 形式提供 Authing 登录 API（`AuthClient`、`OIDCClient`、`UserManager` 等），
原仓库中所有基于 UIKit 的 UI 组件（视图控制器、XIB、按钮、动画、资源目录、本地化）均已移除，
便于在任意宿主框架（AppKit、SwiftUI、UIKit、命令行等）中复用。

`WebKit` 仍用于内部读取 User-Agent 与 logout 时清理 Cookie，这两套 API 在 macOS 与 iOS 上均可用。

如果您需要原版 iOS UI，请使用上游项目：https://github.com/Authing/guard-ios。

## 文档

[中文文档请移步至这里查看](https://docs.authing.cn/v2/reference/sdk-for-ios/)

## 代码示例
https://github.com/Authing/guard-ios-example.

## 常见问题

如果需要在线技术支持，可访问 [官方论坛](https://forum.authing.cn/). 此仓库的 issue 仅用于上报 Bug 和提交新功能特性。

## 贡献

https://github.com/Authing/.github/blob/main/CONTRIBUTING.md

## 开源许可

[MIT](https://opensource.org/licenses/MIT)

Copyright (c) 2019-present Authing

## 获取帮助

若在接入过程中有任何疑问，请添加我们资深 iOS 工程师微信：

<img width="120" src="./doc/images/jianan.png">
