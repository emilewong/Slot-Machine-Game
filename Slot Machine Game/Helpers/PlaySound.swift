//
//  PlaySound.swift
//  Slot Machine Game
//
//  Created by Emile Wong on 2/7/2021.
//

import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR: Could not locate and play the sound file.")
        }
        
    }
}
