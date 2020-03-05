//
//  SpeechRecognition.swift
//  ChatRoom
//
//  Created by Alex on 14.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Speech
import Combine

protocol Recognition {
    func startRecording() -> AnyPublisher<String, TranslationError>
    func stopRecording()
}

class SpeechRecognition: Recognition {
    let engine = AVAudioEngine()
    let req = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var subscriptions = Set<AnyCancellable>()
    func startRecording() -> AnyPublisher<String, TranslationError> {
            //let rec = self.configureRecognitionTask()
            let configurePublisher = self.configureRecognitionTaskC()
            return self.requestAuth()
                    .flatMap(maxPublishers: .max(1)) { _ in
                        configurePublisher
                    }
                    .flatMap(maxPublishers: .max(1)) { rec in
                        self.startRecognitionTask(with: rec)
                    }
                .eraseToAnyPublisher()
        }

    func startRecognitionTask(with recognizer: SFSpeechRecognizer) -> Future<String, TranslationError> {
        return Future<String, TranslationError> { promise in
            recognizer.recognitionTask(with: self.req) { (result, error) in
                if error != nil {
                    self.stopRecording()
                    return promise(.failure(.speech(description: error!.localizedDescription)))
                }
                guard let result = result else {
                    return promise(.failure(.speech(description: "No result")))

                }
                if result.isFinal {
                    self.stopRecording()
                }
                
                return promise(.success(result.bestTranscription.formattedString ?? "No transcription"))
            }
        }
    }
    
    func configureRecognitionTaskC() -> AnyPublisher<SFSpeechRecognizer, TranslationError>{
        return Future<SFSpeechRecognizer, TranslationError> { promise in
            let loc = Locale(identifier: "ru-RU")
            guard let rec = SFSpeechRecognizer(locale:loc) else {
                return promise(.failure(.speech(description: "No such locale")))
            }
            let input = self.engine.inputNode
            input.installTap(onBus: 0, bufferSize: 4096,
                             format: input.outputFormat(forBus: 0)) { buffer, time in
                                self.req.append(buffer)
                                return promise(.success(rec))
            }
            self.engine.prepare()
            do {
                try self.engine.start()
            } catch(let error) {
                return promise(.failure(.speech(description: error.localizedDescription)))
            }
        }.eraseToAnyPublisher()

    }

    func stopRecording() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        req.endAudio()
        //recognitionTask?.cancel()
    }
    
    func requestAuth() -> Future<Bool, TranslationError>{
        return Future<Bool, TranslationError> { promise in
            SFSpeechRecognizer.requestAuthorization { status in
                switch status {
                case .authorized:
                    return promise(.success(true))
                default:
                    return promise(.failure(.speech(description: "Cannot obtain authorization for speech recognition.")))
                }
            }

        }
    }
}
