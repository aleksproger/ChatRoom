//
//  SpeechRecognition.swift
//  ChatRoom
//
//  Created by Alex on 14.01.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Speech


class SpeechRecognition {
    let engine = AVAudioEngine()
    let req = SFSpeechAudioBufferRecognitionRequest()
    
    func startRecording(callback: @escaping (Bool) -> Void) {
        requestAuthorization(callback: callback)
        
        let loc = Locale(identifier: "ru-RU")
        guard let rec = SFSpeechRecognizer(locale:loc) else {
            return
        }
        let input = self.engine.inputNode
        input.installTap(onBus: 0, bufferSize: 4096,
                         format: input.outputFormat(forBus: 0)) { buffer, time in
            self.req.append(buffer)
        }
        self.engine.prepare()
        guard let _ = try? self.engine.start() else {
            print("Can't start engine")
            return
        }
        rec.recognitionTask(with: self.req) { result, err in
            print(result?.bestTranscription)
        }
    }
    
    func stopRecording() {
        engine.stop()
        engine.inputNode.removeTap(onBus: 0)
        req.endAudio()
        //recognitionTask?.cancel()
    }
    
    func requestAuthorization(callback: @escaping (Bool) -> Void){
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                callback(true)
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
