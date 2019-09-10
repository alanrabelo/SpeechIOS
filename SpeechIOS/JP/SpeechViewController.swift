//
//  SpeechViewController.swift
//  SpeechIOS
//
//  Created by João Paulo de Oliveira Sabino on 10/09/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit
import Speech

class SpeechViewController: UIViewController {
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var recButton: UIButton!
    ///Transforma audio em texto
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt-BR"))
    
    ///Cria a requisição e controla o buffer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest!
    
    ///Gerencia a task, pode cancelar ou parar a task atual.
    private var recognitionTask: SFSpeechRecognitionTask?
    
    ///Observa o microfone e gerencia os sinais de audio
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recButton.isEnabled = false
        requestPermissionsForSpeech()
    }
    
    func requestPermissionsForSpeech() {
        SFSpeechRecognizer.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    self.recButton.isEnabled = true
                    print("Autorized")
                } else {
                    print("Not autorized")
                }
            }
        }
    }
    
    @IBAction func recButtonAction(_ sender: Any) {
        audioEngine.isRunning ? stopRec() : startRec()
    }
    
    func startRec() {
        recButton.setTitle("STOP REC", for: .normal)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        let recodingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recodingFormat, block: {(buffer, when) in
            self.recognitionRequest.append(buffer)
        })
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch  {
            print("AudioEngine ERROR: \(error)")
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            if let result = result {
                self.textLabel.text = result.bestTranscription.formattedString
            }
        })
    }
    
    func stopRec() {
        recButton.setTitle("START REC", for: .normal)
        
        //Para a recognitionTask
        recognitionTask?.finish()
        recognitionTask = nil
        
        //Para a gravação de audio
        recognitionRequest.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }

}
