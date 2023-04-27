//
// Created by Agustin Cepeda on 29/03/23.
//

import Foundation
import AVFoundation

class MP3Reader {
  private let channels: UnsafeBufferPointer<UnsafeMutablePointer<Float>>
  private let frame: Float = 5.0
  private var sampleRate: Float

  let duration: Float
  var position: Float = 0.0

  init(fileURL: URL) throws {
    let audioFile = try AVAudioFile(forReading: fileURL)
    let audioAsset = AVURLAsset(url: fileURL)
    let audioFormat = audioFile.processingFormat
    let audioFrameCount = UInt32(audioFile.length)
    let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)


    try audioFile.read(into: audioBuffer!)

    duration = Float(CMTimeGetSeconds(audioAsset.duration))
    sampleRate = Float(audioFormat.sampleRate)
    channels = UnsafeBufferPointer(start: audioBuffer!.floatChannelData,
                                   count: Int(audioBuffer!.format.channelCount))


  }

  func read() -> [[Float]] {
    var audioData = [Float]()
    var audioData2 = [Float]()

    let finalPosition = Int(position + (frame * sampleRate))
    let position = Int(position)

    for sampleIndex in position..<finalPosition {
      audioData.append(channels[0][sampleIndex])
      audioData2.append(channels[1][sampleIndex])
    }

    return [audioData, audioData2]
  }

  func seek(_ position: Float) {
    self.position = position
  }
}