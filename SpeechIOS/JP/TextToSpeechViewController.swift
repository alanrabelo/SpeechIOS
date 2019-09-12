//
//  TextToSpeechViewController.swift
//  SpeechIOS
//
//  Created by João Paulo de Oliveira Sabino on 12/09/19.
//  Copyright © 2019 Alan Victor Paulino de Oliveira. All rights reserved.
//

import UIKit
import AVFoundation

class TextToSpeechViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var speechButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func speechAction(_ sender: Any) {
        let speechSynthesizer = AVSpeechSynthesizer()
        textField.endEditing(true)
        guard let text = textField.text else { return }
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "pt-PT")
        
        speechSynthesizer.speak(speechUtterance)
    }
}
