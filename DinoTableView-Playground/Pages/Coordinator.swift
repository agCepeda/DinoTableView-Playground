//
// Created by Agustin Cepeda on 28/04/23.
//

import UIKit

enum Route {
  case songList
  case songDetail(_ model: Song)
}

protocol Router {
  func navigateTo(_ route: Route)
}



class RouterImpl: Router {

  static let shared: RouterImpl =  RouterImpl()

  lazy var rootViewController: UINavigationController = {
    let songVC = SongListViewController()
    songVC.view.backgroundColor = .systemYellow
    return UINavigationController(rootViewController: songVC)
  }()

  private init() {}

  func navigateTo(_ route: Route) {
    switch route {
    case .songDetail(let song):
      let songDetailVC = SongDetailViewController()
      songDetailVC.viewModel = SongDetailViewModel(model: song)

      rootViewController.show(songDetailVC, sender: nil)
    default: break
    }
  }

}
