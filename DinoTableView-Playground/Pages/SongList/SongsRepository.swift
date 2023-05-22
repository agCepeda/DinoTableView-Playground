//
// Created by Agustin Cepeda on 27/04/23.
//

import Foundation


protocol SongRepository {
  func allSongs() -> [Song]
  func addSong(_ song: Song)
  func getSong() -> Song?
  func deleteSong(_ song: Song)
}

class SongRepositoryImpl: SongRepository {

  static let shared = SongRepositoryImpl()

  private init() {}

  private func retrieveSongs() -> [Song] {
    guard
      let jsonData = UserDefaults.standard.data(forKey: "songs"),
      let songs = try? JSONDecoder().decode([Song].self, from: jsonData)
    else { return [] }

    return songs
  }

  private func storeSongs(songs: [Song]) {
    guard let jsonData = try? JSONEncoder().encode(songs) else { return }

    UserDefaults.standard.set(jsonData, forKey: "songs")
    UserDefaults.standard.synchronize()
  }

  func addSong(_ song: Song) {
    var songs = Set<Song>(retrieveSongs())

    songs.insert(song)

    storeSongs(songs: Array(songs))
  }

  func allSongs() -> [Song] {
    return retrieveSongs()
            .sorted { $0.name.compare($1.name) == .orderedAscending }
  }

  func getSong() -> Song? {
    return retrieveSongs().first
  }

  func deleteSong(_ song: Song) {
  }


}