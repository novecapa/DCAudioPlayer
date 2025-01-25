//
//  AudioPlayerManager.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI
import MediaPlayer
import AVFoundation

protocol AudioPlayerManagerProtocol: AnyObject {
    func audioStateChanged()
    func audioTimeChanged(_ position: Double)
}

@Observable
final class AudioPlayerManager {

    // MARK: - Public Properties
    var isPlaying: Bool = false {
        didSet { delegate?.audioStateChanged() }
    }
    var currentTrack: AudioFileEntity = .empty {
        didSet { loadAudioIfNeeded() }
    }
    var currentPosition: Double = 0 {
        didSet { delegate?.audioTimeChanged(currentPosition) }
    }

    weak var delegate: AudioPlayerManagerProtocol?

    // MARK: - Private Properties
    private var player: AVAudioPlayer?
    private var timer: Timer?
    private let utils: UtilsProtocol
    private let imageCache = NSCache<NSURL, UIImage>()

    // MARK: - Initializer
    init(utils: UtilsProtocol = Utils()) {
        self.utils = utils
    }

    // MARK: - Audio Loading
    func loadAudio(currentTrack: AudioFileEntity) {
        self.currentTrack = currentTrack
    }

    private func loadAudioIfNeeded() {
        guard currentTrack != .empty else { return }

        let url = utils.getFilePath(currentTrack.fileName)
        do {
            stopPlayback()

            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            currentPosition = currentTrack.lastPositionAtSecond

            setupAudioSession()
            setupCommandCenter(title: currentTrack.title, description: currentTrack.desc)
        } catch {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }

    private func stopPlayback() {
        if let player = player {
            player.stop()
        }
        isPlaying = false
        player = nil
    }

    // MARK: - AVAudioSession Setup
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback)
        try? audioSession.setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    // MARK: - Command Center
    private func setupCommandCenter(title: String, description: String) {
        configureNowPlayingInfo(title: title, description: description)

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }

        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }

        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self, let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self.seek(to: event.positionTime)
            return .success
        }

        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 15)]
        commandCenter.skipForwardCommand.addTarget { [weak self] _ in
            self?.forward()
            return .success
        }

        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 15)]
        commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
            self?.backward()
            return .success
        }
    }

    // MARK: - Now Playing Info
    private func configureNowPlayingInfo(title: String, description: String) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: description,
            MPMediaItemPropertyPlaybackDuration: player?.duration ?? 0,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: player?.currentTime ?? 0,
            MPNowPlayingInfoPropertyPlaybackRate: player?.rate ?? 0
        ]

        let coverURL = utils.getFilePath(currentTrack.cover)
        if let image = UIImage(contentsOfFile: coverURL.path) {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    // MARK: - Timer Management
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentPosition = player.currentTime
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Playback Controls
    func play() {
        guard let player = player else { return }
        player.play()
        isPlaying = true
        startTimer()
    }

    func pause() {
        guard let player = player else { return }
        player.pause()
        isPlaying = false
        stopTimer()
    }

    func backward() {
        seek(by: -15)
    }

    func forward() {
        seek(by: 15)
    }

    private func seek(by seconds: TimeInterval) {
        guard let player = player else { return }
        let newTime = max(0, min(player.currentTime + seconds, player.duration))
        seek(to: newTime)
    }

    func seek(to time: TimeInterval) {
        guard let player = player else { return }
        player.currentTime = time
        currentPosition = time
        configureNowPlayingInfo(title: currentTrack.title, description: currentTrack.desc)
    }

    // MARK: - Public Computed Properties
    var duration: Double {
        player?.duration ?? 0
    }

    var currentTime: Double {
        player?.currentTime ?? 0
    }

    var countDownTime: String {
        "-" + (duration - currentTime).toTimming
    }
}
