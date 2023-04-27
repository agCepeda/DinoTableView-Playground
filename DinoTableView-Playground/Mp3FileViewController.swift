//
// Created by Agustin Cepeda on 28/03/23.
//

import UIKit
import MobileCoreServices
import AVFoundation

class Mp3FileViewController: UIViewController, UIDocumentPickerDelegate  {


  lazy var pickButton: UIButton = UIButton(frame: .zero)
  lazy var waveformView: WaveformView = WaveformView(frame: .zero)
  lazy var waveformView2: WaveformView = WaveformView(frame: .zero)
  lazy var slider: UISlider = UISlider(frame: .zero)
  lazy var currentPosition: UILabel = UILabel()
  private var reader: AudioMP3Reader? = nil
  let throttle = Throttle(minimumDelay: 1)

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    // Do any additional setup after loading the view.

    pickButton.setTitle("Pick File", for: .normal)
    pickButton.translatesAutoresizingMaskIntoConstraints = false
    pickButton.addTarget(self, action: #selector(pickMP3File), for: .touchUpInside)
    pickButton.backgroundColor = .red

    updateSliderData()

    let stackView = UIStackView(arrangedSubviews: [waveformView,waveformView2, slider, currentPosition])
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(pickButton)
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      pickButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pickButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      pickButton.widthAnchor.constraint(equalToConstant: 200.0),
      pickButton.heightAnchor.constraint(equalToConstant: 50.0),

      waveformView.heightAnchor.constraint(equalToConstant: 80.0),
      waveformView2.heightAnchor.constraint(equalToConstant: 80.0),

      stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    ])
  }

  @objc func pickMP3File() {
    let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .open)
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = false
    present(documentPicker, animated: true, completion: nil)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let selectedURL = urls.first else { return }
    print("Selected MP3 file: \(selectedURL.lastPathComponent)")
    // Do something with the selected file URL, such as play the mp3 file

    //readMp3File(selectedURL)

    if let reader = try? AudioMP3Reader(fileURL: selectedURL) {
      self.reader = reader

      let audioData = reader.read()

      waveformView.plot(audioData: audioData[0], samplesBySecond: 10)
      waveformView2.plot(audioData: audioData[1], samplesBySecond: 10)
      updateSliderData()


    }


  }

  @IBAction func doSomething(slider: UISlider, forEvent event: UIEvent) {

    currentPosition.text = "\(timeFromSeconds(self.slider.value)) / \(timeFromSeconds(Float(reader?.duration ?? 0)))"

    print(slider.value)

    if let reader = reader {
      reader.seek(Double(slider.value))
      let result = reader.read()

      waveformView.plot(audioData: result[0], samplesBySecond: 1)
      waveformView2.plot(audioData: result[1], samplesBySecond: 1)
    }
  }

  private func setup() {
    slider.isContinuous = false
    slider.maximumValue = 300 //reader?.duration ?? 0
    slider.minimumValue = 0

    slider.addTarget(self, action: #selector(doSomething), for: .valueChanged)
/*
    slider.addAction(UIAction { [self] action in


    }, for: .valueChanged)
*/
    currentPosition.text = "\(timeFromSeconds(0)) / \(timeFromSeconds(Float(reader?.duration ?? 0)))"
  }

  private func updateSliderData() {
    let currentTimeStr = timeFromSeconds(0)
    let totalTimeStr = timeFromSeconds(Float(reader?.duration ?? 0))

    currentPosition.text = "\(currentTimeStr) / \(totalTimeStr)"
  }


  private func timeFromSeconds(_ duration: Float) -> String {
    var remaining = duration

    let hours: Int = Int(remaining / 3600)
    let hoursStr = String(format: "%02d", hours)
    remaining = remaining - Float(hours * 3600)

    let minutes: Int = Int(remaining / 60)
    let minutesStr = String(format: "%02d", minutes)
    remaining = remaining - Float(minutes * 60)

    let seconds: Int = Int(remaining)
    let secondsStr = String(format: "%02d", seconds)

    if hours > 0 {
      return "\(hoursStr):\(minutesStr):\(secondsStr)"
    } else {
      return "\(minutesStr):\(secondsStr)"
    }


  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    dismiss(animated: true, completion: nil)
  }
}
class WaveformView: UIView {
  var audioData = [Float]()
  var lineWidth: CGFloat = 1.0
  var lineColor: UIColor = UIColor.black
  private var offset: Int = 3000
  private var samplesBySecond: Int = 0

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    let context = UIGraphicsGetCurrentContext()
    context?.clear(rect)

    let rect = rect.inset(by: .init(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0))

    // Draw the waveform using the audio data
    let path = UIBezierPath()
    path.lineWidth = lineWidth
    lineColor.setStroke()


    let scaleFactor = rect.height / 2.0
    let centerY = rect.height / 2.0

    path.move(to: CGPoint(x: 0, y: centerY))
    for (index, sample) in audioData.enumerated() {
      let x = CGFloat(index) / CGFloat(audioData.count) * rect.width
      let y = CGFloat(sample) * scaleFactor + centerY
      path.addLine(to: CGPoint(x: x, y: y))

    }

    UIColor.green.setStroke()
    path.stroke()
  }

  func plot(audioData: [Float], samplesBySecond: Int) {
    self.audioData = audioData
    self.samplesBySecond = samplesBySecond
    setNeedsDisplay()

  }
  /*
  func plot(audioData: [Float]) {
    self.audioData = audioData
    setNeedsDisplay()
  }*/
  func set(offset: Int) {
    self.offset = offset
    setNeedsDisplay()
  }
}