//
// Created by Agustin Cepeda on 28/04/23.
//

import Foundation
import AVFoundation

struct Clip {
  var duration: Double
  var lowerPosition: Double = 0
  var upperPosition: Double = 0
}

struct SongClipCellViewModel {
  var clip: Clip
  var onPlay: () -> Void
  var onSetLowerPosition: (Double) -> Void
  var onSetUpperPosition: (Double) -> Void
}

let updatePlayerInterval = TimeInterval(0.5)

class SongDetailViewModel: NSObject, AVAudioPlayerDelegate {

  let playerQueue = DispatchQueue(label: "dinosaur.audio-player", qos: .default)

  var audioPlayer: AVAudioPlayer?
  var timer: Timer?

  var model: Song
  var clips: [Clip] = []
  var clipViewModels: [SongClipCellViewModel] {
    clips.enumerated().map { index, element  in
      SongClipCellViewModel(clip: element,
                            onPlay: onPlayClip(at: index),
                            onSetLowerPosition: setLowerPosition(index: index),
                            onSetUpperPosition: setUpperPosition(index: index))
    }
  }

  private func onPlayClip(at index: Int) -> () -> Void {
    {
      let clip = self.clips[index]

      self.timer = Timer(timeInterval: updatePlayerInterval, repeats: true) { _ in

      }

      self.audioPlayer?.play(atTime: TimeInterval(clip.lowerPosition))
    }
  }

  private func setLowerPosition(index: Int) -> (Double) -> Void {
    { (position: Double)  in
      var clips = self.clips
      var clip = self.clips[index]

      clip.lowerPosition = position

      clips[index] = clip
      self.clips = clips
    }
  }

  private func setUpperPosition(index: Int) -> (Double) -> Void {
    { (position: Double) in
      var clips = self.clips
      var clip = self.clips[index]

      clip.upperPosition = position

      clips[index] = clip
      self.clips = clips
    }
  }

  var titleText: String {
    return model.name
  }
  private var duration: Double = 0.0

  init(model: Song) {
    self.model = model
    super.init()
    self.loadAudioFile()
  }

  func loadAudioFile() {
    // Assuming the audio file is in your project folder and named "audioFile.mp3"
    guard let audioURL = URL(string: model.uri), let audioFile = try? AVAudioFile(forReading: audioURL) else {
      print("Audio file not found")
      return
    }

    duration = Double(audioFile.length) / audioFile.fileFormat.sampleRate

    do {
      audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
      audioPlayer?.prepareToPlay()
      audioPlayer?.delegate = self
    } catch {
      print("Error loading audio file: \(error.localizedDescription)")
    }
  }

  func playAudio() {
    audioPlayer?.play()
  }

  func addClip() {
    clips.append(Clip(duration: duration))
  }

  func playClip(_ clip: Clip) {
  }

}

extension AVAudioPlayerDelegate {
  public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

  }

  public func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
  }

  public func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
  }

  public func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
  }
}