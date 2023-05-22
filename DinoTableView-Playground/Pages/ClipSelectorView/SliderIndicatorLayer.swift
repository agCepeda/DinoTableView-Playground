//
// Created by Agustin Cepeda on 20/05/23.
//

import UIKit

class SliderRangeStateManager {
  enum Indicator {
    case lower
    case upper
  }

  private var indicator: Indicator? = nil

  func useIndicator(_ indicator: Indicator) {
    self.indicator = indicator
  }
}

class SliderIndicatorLayer: CAShapeLayer {

  struct Constants {
    static let animationDuration = CFTimeInterval(0.25)
    static let indicatorWidth = CGFloat(20.0)
    static let indicatorRadius = CGFloat(Constants.indicatorWidth * 0.5)

    static let indicatorSize = CGSize(width: Constants.indicatorWidth, height: Constants.indicatorWidth)

    static let increaseScaleFactor: CGFloat = 1.5
    static let increaseScaleTransform = CATransform3DScale(CATransform3DIdentity,
                                                           Constants.increaseScaleFactor,
                                                           Constants.increaseScaleFactor, 1)
  }

  override init() {
    super.init()
    drawShape()
  }

  required init?(coder: NSCoder) {
    super.init()
    drawShape()
  }

  override func layoutSublayers() {
    super.layoutSublayers()
    drawShape()
  }

  func drawShape() {
    let origin = CGPoint(x: bounds.midX - Constants.indicatorRadius,
                         y: bounds.midY - Constants.indicatorRadius)
    let roundedRect = CGRect(origin: origin, size: Constants.indicatorSize)

    let indicatorShape = UIBezierPath(roundedRect: roundedRect, cornerRadius: Constants.indicatorRadius)

    path = indicatorShape.cgPath
    frame = CGRect(origin: frame.origin, size: Constants.indicatorSize)
  }


  func pressAnimation() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    transform = Constants.increaseScaleTransform
    CATransaction.commit()

    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = CATransform3DIdentity
    animation.toValue = Constants.increaseScaleTransform
    animation.duration = Constants.animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    add(animation, forKey: nil)
  }

  func releaseAnimation() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    transform = CATransform3DIdentity
    CATransaction.commit()

    let animation = CABasicAnimation(keyPath: "transform")
    animation.fromValue = Constants.increaseScaleTransform
    animation.toValue = CATransform3DIdentity
    animation.duration = Constants.animationDuration
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    add(animation, forKey: nil)
  }

  override func preferredFrameSize() -> CGSize {
    Constants.indicatorSize
  }
}
