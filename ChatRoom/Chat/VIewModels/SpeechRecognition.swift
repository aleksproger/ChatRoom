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
    func startRecording(callback: @escaping(Bool) -> Void)
    func stopRecording()
}

class SpeechRecognition: Recognition {
    let engine = AVAudioEngine()
    let req = SFSpeechAudioBufferRecognitionRequest()
    var subscriptions = Set<AnyCancellable>()
    
    func startRecordingCombine() -> AnyPublisher<String, TranslationError> {
            let rec = self.configureRecognitionTask()
            return self.requestAuth()
                .flatMap(maxPublishers: .max(1)) { (isAuthorized) in
                    self.startRecognitionTask(with: rec!)
                }
            .eraseToAnyPublisher()
    }
    func startRecording(callback: @escaping (Bool) -> Void) {
        let rec = self.configureRecognitionTask()
        //requestAuthorization(rec: rec!, callback: callback)
        
        self.requestAuth()
            .flatMap(maxPublishers: .max(1)) { (isAuthorized) in
                self.startRecognitionTask(with: rec!)
            }
        .sink(receiveCompletion: { (completion) in
            switch completion {
            case .finished:
                print("Finished")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }) { (translation) in
            print(translation)
        }
    .store(in: &subscriptions)
//        rec!.recognitionTask(with: self.req) { result, err in
//            print(result?.bestTranscription.formattedString)
//        }
        
//        self.requestAuth()
//            .sink(receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    print(error)
//                }
//            }, receiveValue: { value in
//                let rec = self.configureRecognitionTask()
//                rec!.recognitionTask(with: self.req) { result, err in
//                    print(result?.bestTranscription.formattedString)
//                }
//            })
//        .store(in: &subscriptions)

    }
    
    func startRecognitionTask(with recognizer: SFSpeechRecognizer) -> Future<String, TranslationError> {
        return Future<String, TranslationError> { promise in
            recognizer.recognitionTask(with: self.req) { (result, error) in
                if error != nil {
                    return promise(.failure(.speech(description: error!.localizedDescription)))
                }
                return promise(.success(result?.bestTranscription.formattedString ?? "No transcription"))
            }
        }
    }
    
    func configureRecognitionTask() -> SFSpeechRecognizer?{
        let loc = Locale(identifier: "ru-RU")
        guard let rec = SFSpeechRecognizer(locale:loc) else {
            return nil
        }
        let input = self.engine.inputNode
        input.installTap(onBus: 0, bufferSize: 4096,
                         format: input.outputFormat(forBus: 0)) { buffer, time in
            self.req.append(buffer)
        }
        self.engine.prepare()
        guard let _ = try? self.engine.start() else {
            print("Can't start engine")
            return nil
        }
        return rec
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
    func requestAuthorization(rec: SFSpeechRecognizer, callback: @escaping (Bool) -> Void){
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                callback(true)
                rec.recognitionTask(with: self.req) { result, err in
                    print(result?.bestTranscription.formattedString)
                }
            case .denied:
                callback(false)
            case .restricted:
                callback(false)
            case .notDetermined:
                callback(false)
            @unknown default:
                fatalError()
            }
        }
    }
}
