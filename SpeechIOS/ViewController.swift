//
//  ViewController.swift
//  SpeechIOS
//
//  Created by Alan Victor Paulino de Oliveira on 06/09/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        requestPermissionsForSpeech()
    }

    func requestPermissionsForSpeech() {
        SFSpeechRecognizer.requestAuthorization { (status) in
            DispatchQueue.main.async {
                if status == .authorized {
                    print("Autorized")
                    var url = Bundle.main.url(forResource: "teste", withExtension: "mp3")
//                    var url = URL.init(fileURLWithPath: "us000121") as? URL
                    guard let url2 = url else { return }
                    self.transcribeAudio(url: url2)
                } else {
                    print("Not autorized")
                }
            }
        }
    }
    
    func transcribeAudio(url: URL) {
        let recognize = SFSpeechRecognizer()
        let request =  SFSpeechURLRecognitionRequest(url: url)
        
        recognize?.recognitionTask(with: request, resultHandler: { (result, error) in
            guard let result = result else {
                print("No this time")
                return }
            if result.isFinal {
                
                print(result.bestTranscription.formattedString)
            }
        })
    }
}

