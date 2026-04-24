//
//  AuthingWebsocketClient.swift
//  Guard
//
//  Created by JnMars on 2023/2/27.
//

import Foundation

@available(iOS 13.0, *)
public class AuthingWebsocketClient: NSObject {
    private var webSocketTask: URLSessionWebSocketTask!
    private var urlString: String = ""
    private var retryCount: Int = 3
    private var retryTimes: Int = 0
    private var receiveCallBack: ((Int, String?) -> Void)?

    public func setRetryCount(_ count: Int) {
        retryCount = count
    }

    public func initWebSocket(urlString: String, completion: @escaping (Int, String?) -> Void) {
        receiveCallBack = completion
        self.urlString = urlString
        webSocketConnect(urlString: urlString)
    }

    private func webSocketConnect(urlString: String) {
        guard let url = URL(string: urlString) else {
            ALog.e(AuthingWebsocketClient.self, "Error: can not create URL")
            return
        }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let request = URLRequest(url: url)
        webSocketTask = urlSession.webSocketTask(with: request)
        webSocketTask.resume()

        webSocketTask.receive { result in
            switch result {
            case let .success(message):
                switch message {
                case let .string(text):
                    ALog.d(AuthingWebsocketClient.self, text)
                    self.receiveCallBack?(200, text)
                case let .data(data):
                    ALog.d(AuthingWebsocketClient.self, "\(data)")
                    self.receiveCallBack?(200, "\(data)")
                @unknown default:
                    fatalError()
                }
            case let .failure(error):
                ALog.e(AuthingWebsocketClient.self, error)
                self.receiveCallBack?((error as NSError).code, (error as NSError).debugDescription)
            }
        }

        sendPing()
    }

    public func cancel() {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }

    func sendPing() {
        webSocketTask.sendPing { error in
            if let error = error {
                ALog.w(AuthingWebsocketClient.self, "Sending PING failed: \(error)")
                self.webSocketTask = nil
                self.webSocketConnect(urlString: self.urlString)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.sendPing()
            }
        }
    }
}

@available(iOS 13.0, *)
extension AuthingWebsocketClient: URLSessionWebSocketDelegate {
    public func urlSession(_: URLSession,
                           webSocketTask _: URLSessionWebSocketTask,
                           didOpenWithProtocol _: String?)
    {
        ALog.d(AuthingWebsocketClient.self, "URLSessionWebSocketTask is connected")
    }

    public func urlSession(_: URLSession,
                           webSocketTask _: URLSessionWebSocketTask,
                           didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
                           reason: Data?)
    {
        let reasonString: String
        if let reason = reason, let string = String(data: reason, encoding: .utf8) {
            reasonString = string
        } else {
            reasonString = ""
        }
        ALog.e(AuthingWebsocketClient.self, "URLSessionWebSocketTask is closed: code=\(closeCode), reason=\(reasonString)")
    }
}
