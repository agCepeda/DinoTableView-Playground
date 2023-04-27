//
// Created by Agustin Cepeda on 07/04/23.
//

import AVFAudio

struct AudioMP3FrameCalculator {

  var length: UInt32
  var frame: UInt32

  private func fixStartPosition(_ position: Int) -> Int {
    let halfSamples: Int = Int(Double(frame) * 0.5)

    if position <= halfSamples {
      return 0
    } else if position >= Int(length) - halfSamples {
      return Int(length - frame)
    } else {
      return position - halfSamples
    }
  }

  func calculate(_ position: Int) -> (Int, Int) {
    let start = fixStartPosition(position)

    return (start, start + Int(frame))
  }
}

class AudioMP3Reader {
  private let file: AVAudioFile
  let duration: Double
  private let sampleRate: Double
  private let frame: Double = 0.2
  private var position: Double = 0.0
  var calculator: AudioMP3FrameCalculator
  private let audioBuffer: AVAudioPCMBuffer
  private let buffer: UnsafeBufferPointer<UnsafeMutablePointer<Float>>

  init(fileURL: URL) {
    guard let audioFile = try? AVAudioFile(forReading: fileURL) else { fatalError() }

    file = audioFile
    sampleRate = audioFile.fileFormat.sampleRate
    duration = Double(audioFile.length) / sampleRate


    guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: UInt32(sampleRate * frame))
      else { fatalError() }

    self.audioBuffer = audioBuffer

    buffer =  UnsafeBufferPointer(start: audioBuffer.floatChannelData,
      count: Int(audioBuffer.format.channelCount))

    calculator = AudioMP3FrameCalculator(length: UInt32(audioFile.length),
                                         frame: UInt32(audioFile.fileFormat.sampleRate * frame))
  }

  func seek(_ position: Double) {
    self.position = position
  }

  func read() -> [[Float]] {
    let (start, end) = calculator.calculate(Int(position * sampleRate))
    
    file.framePosition = AVAudioFramePosition(start)

    try? file.read(into: audioBuffer)

    
                                                                                                
    var audioData = [Float]()
    var audioData2 = [Float]()

    for sampleIndex in 0..<(end - start) {
      audioData.append(buffer[0][sampleIndex])
      audioData2.append(buffer[1][sampleIndex])
    }

    return [audioData, audioData2]
  }

}


