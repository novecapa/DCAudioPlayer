//
//  AudioPlayerManager.swift
//  DCAudioPlayer
//
//  Created by Josep Cerdá Penadés on 20/1/25.
//

import SwiftUI
import MediaPlayer
import AVFoundation

protocol AudioPlayerManagerProtocol {
    func audioStateChanged()
    func audioTimeChanged(_ position: Double)
}

@Observable
final class AudioPlayerManager {

    var isPlaying: Bool = false
    var currentTrack: AudioFileEntity = .empty
    var currentPosition: Double = 0

    private var player: AVAudioPlayer?
    private var timer: Timer?
    var delegate: AudioPlayerManagerProtocol?

    private let utils: UtilsProtocol
    init(utils: UtilsProtocol = Utils()) {
        self.utils = utils
    }

    func loadAudio(currentTrack: AudioFileEntity) {
        guard self.currentTrack != currentTrack else {
            startTimer()
            return
        }
        self.currentTrack = currentTrack
        let url = utils.getFilePath(currentTrack.fileName)
        do {
            if player != nil {
                player?.stop()
                isPlaying = false
                player = nil
            }
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            currentPosition = currentTrack.lastPositionAtSecond
            setupAVAudioSession()
            setupCommandCenter(title: currentTrack.title,
                               description: currentTrack.desc)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func setupAVAudioSession() {
        let audioInstance = AVAudioSession.sharedInstance()
        try? audioInstance.setCategory(.playback)
        try? audioInstance.setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    private func setupCommandCenter(title: String,
                                    description: String) {
        setupInfoMediaPlayer(title: title, description: description)

        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.isEnabled = true

        // Seek
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self, let event = event as? MPChangePlaybackPositionCommandEvent else {
                return .commandFailed
            }
            self.seek(to: event.positionTime)
            return .success
        }
        // Play
        commandCenter.playCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.play()
            return .success
        }
        // Pause
        commandCenter.pauseCommand.addTarget { [weak self] (_) -> MPRemoteCommandHandlerStatus in
            self?.pause()
            return .success
        }
        // Forward
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [NSNumber(value: 15)]
        commandCenter.skipForwardCommand.addTarget { [weak self] _ in
            self?.forward()
            return .success
        }
        // Backward
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [NSNumber(value: 15)]
        commandCenter.skipBackwardCommand.addTarget { [weak self] _ in
            self?.backward()
            return .success
        }
    }

    func seek(to time: TimeInterval) {
        let targetTime = CMTime(seconds: time, preferredTimescale: 1)
        seekTo(targetTime.seconds)
        updateNowPlayingInfo()
    }

    func updateNowPlayingInfo() {
        if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }

    let imageCache = NSCache<NSURL, UIImage>()
    private func setupInfoMediaPlayer(title: String,
                                      description: String) {
        // Playing info center singleton
        let playingInfoCenter = MPNowPlayingInfoCenter.default()
        var nowPlayingInfo = [String: Any]()

        // Prepare title and subtitle
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = description

        // Time status
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime

        // TODO: ---
//        guard let iconURL = currentTrack.coverUrl else { return }
//        if let cachedImage = imageCache.object(forKey: iconURL as NSURL) {
//            let artwork = MPMediaItemArtwork(boundsSize: cachedImage.size) { _ in cachedImage }
//            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
//            playingInfoCenter.nowPlayingInfo = nowPlayingInfo
//        } else {
//            URLSession.shared.dataTask(with: iconURL) { [weak self] data, _, _ in
//                guard let self = self,
//                      let data = data,
//                      let downloadedImage = UIImage(data: data) else {
//                    return
//                }
//                DispatchQueue.main.async {
//                    self.imageCache.setObject(downloadedImage, forKey: iconURL as NSURL)
//                    let artwork = MPMediaItemArtwork(boundsSize: downloadedImage.size) { _ in downloadedImage }
//                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
//                    playingInfoCenter.nowPlayingInfo = nowPlayingInfo
//                }
//            }.resume()
//        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.player else { return }
            self.currentPosition = player.currentTime
            self.updateNowPlayingInfo()
            guard self.currentPosition > 0 else { return }
            self.delegate?.audioTimeChanged(self.currentPosition)
        }
    }
}
// MARK: Public methods
extension AudioPlayerManager {
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
        guard let player = player else { return }
        player.currentTime -= 15
    }

    func forward() {
        guard let player = player else { return }
        player.currentTime += 15
    }

    func seekTo(_ position: Double) {
        guard let player = player else { return }
        player.currentTime = position
        currentPosition = position
    }

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
