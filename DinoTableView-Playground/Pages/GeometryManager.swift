//
// Created by Agustin Cepeda on 06/05/23.
//

import UIKit

class GeometryManager {
  var sliderBarHeight: CGFloat = 0
  var sliderBarWidth: CGFloat = 0
  var sliderBarX: CGFloat = 0
  var sliderBarY: CGFloat = 0
  var sliderIndicatorWidth: CGFloat = 0


  lazy var sliderBarFrame: CGRect = {
    .init(x: sliderBarX, y: sliderBarY, width: sliderBarWidth, height: sliderBarHeight)
  }()
  lazy var indicatorFrame: CGRect = {
    .init(origin: .zero, size: .init(width: sliderIndicatorWidth, height: sliderIndicatorWidth))
  }()
  lazy var indicatorCornerRadius: CGFloat = {
    sliderIndicatorWidth * 0.5
  }()

  init(sliderBarHeight: CGFloat, sliderIndicatorWidth: CGFloat, frame: CGRect) {
    self.sliderIndicatorWidth = sliderIndicatorWidth
    self.sliderBarHeight = sliderBarHeight
    sliderBarWidth = frame.width - sliderIndicatorWidth

    sliderBarX = sliderIndicatorWidth * 0.5
    sliderBarY = (sliderIndicatorWidth - sliderBarHeight) * 0.5
  }

  func calculatePositionX(_ position: CGPoint) -> CGFloat {
    if position.x < sliderBarX {
      return sliderBarX
    }

    if position.x > sliderBarX + sliderBarWidth {
      return sliderBarX + sliderBarWidth
    }

    return position.x
  }

  func calculatePercentage(_ x: CGFloat) -> CGFloat {
    let quantity = x - sliderBarX
    let relation = quantity / sliderBarWidth

    return relation
  }

}