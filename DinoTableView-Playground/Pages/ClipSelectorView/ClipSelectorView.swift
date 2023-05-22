//
// Created by Agustin Cepeda on 03/05/23.
//

import UIKit


class ClipSelectorView: UIView {

  struct Constants {
    static let pinWidth: CGFloat = 30.0
    static let pinHeight: CGFloat = 70.0
  }

  private var manager: GeometryManager!
  var stateManager: SliderRangeStateManager = SliderRangeStateManager()
  private var currentIndicator: SliderIndicatorLayer?
  private var lastFrame: CGRect = .zero
  private var lastPosition:CGFloat = 0

  lazy var lowerIndicator: SliderIndicatorLayer = SliderIndicatorLayer()
  lazy var upperIndicator: SliderIndicatorLayer = SliderIndicatorLayer()
  lazy var sliderBarLayer: CAShapeLayer = CAShapeLayer()

  var onValueChanged: (Double, Double) -> Void = { _, _ in  }

  var minimumValue: Double = 0 {
    didSet { configChanged() }
  }
  var maximumValue: Double = 5 {
    didSet { configChanged() }
  }

  private func configChanged() {
    setNeedsDisplay()
  }

  init() {
    super.init(frame: .zero)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    sliderBarLayer.fillColor = UIColor.systemGray.cgColor
    lowerIndicator.fillColor = UIColor.systemTeal.cgColor
    upperIndicator.fillColor = UIColor.systemMint.cgColor
    layer.addSublayer(sliderBarLayer)
    layer.addSublayer(lowerIndicator)
    layer.addSublayer(upperIndicator)

    clipsToBounds = true
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touchPosition = touches.first?.location(in: self) else { return }

    switch (lowerIndicator.frame.contains(touchPosition),
            upperIndicator.frame.contains(touchPosition)) {
    case (true, false):
      stateManager.useIndicator(.lower)
      currentIndicator = lowerIndicator
    case (false, true):
      stateManager.useIndicator(.upper)
      currentIndicator = upperIndicator
    case (true, true):
      currentIndicator = upperIndicator
    case (_, _): break
    }

    if let currentIndicator = currentIndicator {
      vibrate()
      currentIndicator.pressAnimation()
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)

    guard let position = touches.first?.location(in: self), let currentIndicator = currentIndicator else { return }

    let positionX = manager.calculatePositionX(position)

    if currentIndicator == lowerIndicator, !(positionX < upperIndicator.frame.minX) {
      return
    }

    if currentIndicator == upperIndicator, !(positionX > lowerIndicator.frame.maxX) {
      return
    }

    let percentage = manager.calculatePercentage(positionX)
    let range = maximumValue - minimumValue
    let value = range * percentage

    CATransaction.begin()
    CATransaction.setDisableActions(true)

    currentIndicator.position = CGPoint(x: positionX, y: bounds.midY)

    CATransaction.commit()
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    if let currentIndicator = currentIndicator {
      vibrate()
      currentIndicator.releaseAnimation()
    }

    currentIndicator = nil
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if lastFrame != frame {
      print(frame)
      manager = GeometryManager(sliderBarHeight: 4.0, sliderIndicatorWidth: 30.0, frame: frame)
      lastFrame = frame

      lowerIndicator.position = CGPoint(x: 15.0, y: bounds.midY)
      upperIndicator.position = CGPoint(x: frame.width - 15.0, y: bounds.midY)

      setNeedsDisplay()
    }
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)
    let sliderBarShape = UIBezierPath(roundedRect: manager.sliderBarFrame, cornerRadius: 2.0)

    UIColor.red.setStroke()
    UIColor.systemGreen.setFill()

    sliderBarLayer.path = sliderBarShape.cgPath
    sliderBarLayer.frame = rect
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 30.0)
  }

  func vibrate() {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
  }
}