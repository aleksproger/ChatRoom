//
//  APIManager.swift
//  ChatRoom
//
//  Created by Alex on 06.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

final class APIManager {
    func translate(_ translationType: TranslationType, text: String, completion: @escaping  (String) -> Void)  {
        switch translationType {
        case .engToRus:
            makeEngToRusRequest(text: text) { translation in
                print("Translation - \(translation)")
                completion(translation)
            }
        case .rusToEng:
            makeRusToEngRequest(text: text) { translation in
                completion(translation)
            }
        }
    }
}

private extension APIManager {
    struct YandexTranslatorAPI {
        static let scheme = "https"
        static let host = "translate.yandex.net"
        static let path = "/api/v1.5/tr.json/translate"
        static let key = "trnsl.1.1.20200106T203937Z.d696c26cf9e390e9.761efa2b81cd8dfb8f9a9227fca294ab47ccf81c"
    }
    
    func makeEngToRusRequest(text: String, completion: @escaping (String) -> Void) {
        let request = makeRequest(translation: "en-ru", text: text)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(data)
            if let data = data, let request = try? JSONDecoder.init().decode(TranslationRequest.self, from: data) {
                print(request.text[0])
                let translation = request.text[0]
                completion(translation)
            }
        }
        task.resume()
    }
    
    func makeRusToEngRequest(text: String, completion: @escaping (String) -> Void) {
        let request = makeRequest(translation: "ru-en", text: text)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(data)
            if let data = data, let request = try? JSONDecoder.init().decode(TranslationRequest.self, from: data) {
                print(request.text[0])
                let translation = request.text[0]
                completion(translation)
            }
        }
        task.resume()
    }
    
    func makeURLComponents(translation: String, text: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = YandexTranslatorAPI.scheme
        components.host = YandexTranslatorAPI.host
        components.path = YandexTranslatorAPI.path
        components.queryItems = [
          URLQueryItem(name: "lang", value: translation),
          URLQueryItem(name: "key", value: YandexTranslatorAPI.key),
        ]
        return components
    }
    
    func makeRequest(translation: String, text: String) -> URLRequest {
        let components = makeURLComponents(translation: translation, text: text)
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data = "text=\(text)".data(using: .utf8)
        urlRequest.httpBody = data!
        return urlRequest
    }
}
