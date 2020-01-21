//
//  ChatService.swift
//  ChatRoom
//
//  Created by Alex on 06.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Starscream
import Combine

class ChatService {
    private var isConnected = false
    private var socket: WebSocket?
    static let shared = ChatService()
    private var username = "Alex"
    private init () {}
    var messageReceived = PassthroughSubject<Message, Never>()
    var joinMessageReceived = PassthroughSubject<String, Never>()
    
    func setupNetworkCommunication() {
        let request = URLRequest(url: URL(string: "ws://localhost:8080/echo-test")!)
        socket = WebSocket(request: request)
        guard let socket = socket else {
            return
        }
        socket.delegate = self
        socket.connect()
        print("connected")
    }
    
    func joinChat(username: String)  {
        self.username = username
        self.writeMessage("iam:\(username)")
    }
    func writeMessage(_ text: String) {
        guard let socket = socket else {
            print("no socket")
            return
        }
        socket.write(string: text)
    }
    
    func sendMessaage(_ message: OutputMessage) {
        guard let socket = socket else {
            print("no socket")
            return
        }
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(message)
        guard data != nil else {
            return
        }
        socket.write(data: data!) 
    }
    
    func receiveJoinMessage(text: String) {
        joinMessageReceived.send(text)
    }
    
    func receiveMessageObject(data: Data) {
        let messageDecoded = try? JSONDecoder.init().decode(Message.self, from: data)
        guard var message = messageDecoded else {
            return
        }
        message.messageSender = (message.senderUsername == self.username) ? .ourself : .somebody
        messageReceived.send(message)

    }
    
    func closeNetworkCommunication() {
        guard let socket = socket else {
            return
        }
        socket.disconnect()
    }
}

extension ChatService: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("Client websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("Client websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Client received text: \(string)")
            self.receiveJoinMessage(text: string)
        case .binary(let data):
            self.receiveMessageObject(data: data)
            print("Client received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viablityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print("error")
            //handleError(error)
        }
    }
    
    
}
