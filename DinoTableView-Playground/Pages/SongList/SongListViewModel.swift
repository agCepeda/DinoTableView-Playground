//
// Created by Agustin Cepeda on 27/04/23.
//

import Foundation

struct Song: Codable {
  let name: String
  let uri: String
  var url: URL? {
    return URL(string: uri)
  }

  static func initFromURL(_ url: URL) -> Song {
    return Song(name: url.lastPathComponent, uri: url.absoluteString)
  }
}

extension Song: Hashable {
}

struct SongListCellViewModel {
  var model: Song

  public var titleText: String {
    return model.url?.lastPathComponent ?? ""
  }
}

enum SongListCellType {
  case empty
  case item(_ cellViewModel: SongListCellViewModel)
}

struct SongListViewModel {

  var songRepository: SongRepository
  var router: Router
  var songs: [Song] = [] { didSet { reloadListItems() } }
  var songListCellTypes: [SongListCellType] = []

  init(songRepository: SongRepository = SongRepositoryImpl.shared,
       router: Router = RouterImpl.shared) {
    self.songRepository = songRepository
    self.router = router
    self.loadSongs()
  }

  mutating func loadSongs() {
    songs = songRepository.allSongs()
  }
  
  private mutating func reloadListItems()  {
    self.songListCellTypes = calculateListItems()
  }

  private func calculateListItems() -> [SongListCellType] {
    guard !songs.isEmpty else { return [.empty] }

    return songs.map { .item(SongListCellViewModel(model: $0)) }
  }

  mutating func addSong(_ url: URL) {
    songRepository.addSong(Song.initFromURL(url))
    songs = songRepository.allSongs()
  }

  func showSongDetail(_ song: Song) {
    router.navigateTo(.songDetail(song))
  }

}

