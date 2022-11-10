//
//  AudioManager.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit
import AVFoundation


enum SoundType {
    case splash
    case win
    case loss
    
    var name: String {
        switch self {
        case .splash:
            return "water-splash"
        case .win:
            return "winSound"
        case .loss:
            return "failureSound"
        }
    }

    var numberOfLoops: Int {
        switch self {
        case .splash:
            return 0
        case .win:
            return 0
        case .loss:
            return 0
        }
    }
}

class AudioManager: NSObject {
    static let shared = AudioManager()
    var IsVibrationOn = true
    private var isPlayerSuccesSound = false
    var isSilent: Bool = false {
        didSet {
            if isSilent {
                if let player = player,
                   player.isPlaying {
                    player.pause()
                }
            } else {
                player?.play()
            }
        }
    }
    private(set) var player: AVAudioPlayer?
    
    private(set) var soundPlayer: AVAudioPlayer?
    
    func playSound(_ type: SoundType) {
        if type == .win || type == .loss {
            isPlayerSuccesSound = true
        }
        guard let url = Bundle.main.url(forResource: type.name,
                                        withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = soundPlayer else { return }
            player.volume = 1
            player.numberOfLoops = type.numberOfLoops
            player.play()
            player.delegate = self
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "backgroundMusic",
                                        withExtension: "mp3") else { return }
        guard !isSilent else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.volume = 0.5
            player.numberOfLoops = -1
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func vibrate() {
        if IsVibrationOn {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}



extension AudioManager: AVAudioPlayerDelegate {
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if player == soundPlayer {
                if isPlayerSuccesSound {
                    isPlayerSuccesSound = false
                    self.player?.play()
                }
            }
        }
    }
    
}
