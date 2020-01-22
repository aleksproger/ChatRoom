//
//  APIManager.swift
//  ChatRoom
//
//  Created by Alex on 06.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Combine

protocol Translator {
    func translate(_ translationType: TranslationType, text: String) -> AnyPublisher<String, TranslationError>
}

final class YandexTranslator: Translator {
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func translate(_ translationType: TranslationType, text: String) -> AnyPublisher<String, TranslationError> {
        guard let request = makeRequest(translation: translationType.rawValue, text: text) else {
            let error = TranslationError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .mapError { (error) -> TranslationError in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            self.decode(pair.data)
        }
        .map { req in
            req.text[0]
        }
        .eraseToAnyPublisher()
    }
    

}

private extension YandexTranslator {
    struct YandexTranslatorAPI {
        static let scheme = "https"
        static let host = "translate.yandex.net"
        static let path = "/api/v1.5/tr.json/translate"
        static let key = "trnsl.1.1.20200106T203937Z.d696c26cf9e390e9.761efa2b81cd8dfb8f9a9227fca294ab47ccf81c"
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
    
    func makeRequest(translation: String, text: String) -> URLRequest? {
        let components = makeURLComponents(translation: translation, text: text)
        guard let url = components.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let data = "text=\(text)".data(using: .utf8)
        urlRequest.httpBody = data!
        return urlRequest
    }
    
    func decode(_ data: Data) -> AnyPublisher<TranslationRequest, TranslationError>{
        let decoder = JSONDecoder()
        return Just(data)
          .decode(type: TranslationRequest.self, decoder: decoder)
          .mapError { error in
            .network(description: error.localizedDescription)
          }
          .eraseToAnyPublisher()
    }
    
}
