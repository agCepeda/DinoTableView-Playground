//
// Created by Agustin Cepeda on 27/04/23.
//

import UIKit
import MobileCoreServices

class SongListEmptyCell: UITableViewCell {}

class SongListItemCell: UITableViewCell {}

extension UITableViewCell {
  public static var identifier: String {
    return String(describing: self)
  }
}

class SongListViewController: UITableViewController, UIDocumentPickerDelegate {

  var viewModel: SongListViewModel = SongListViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(SongListItemCell.self, forCellReuseIdentifier: SongListItemCell.identifier)
    tableView.register(SongListEmptyCell.self, forCellReuseIdentifier: SongListEmptyCell.identifier)

    setupNavigationBar()
  }

  func setupNavigationBar() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onLeftButtonTapped))
  }

  @objc func onLeftButtonTapped() {
    let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeMP3 as String], in: .open)
    documentPicker.delegate = self
    documentPicker.allowsMultipleSelection = true
    documentPicker
    present(documentPicker, animated: true, completion: nil)
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    for selectedURL in urls {
      viewModel.addSong(selectedURL)
      tableView.reloadData()
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.songListCellTypes.count
  }

  func bindEmptyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SongListEmptyCell.identifier,
                                                              for: indexPath) as? SongListEmptyCell
    else { return .init() }


    return cell
  }
  func bindItemCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, cellViewModel:  SongListCellViewModel) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SongListItemCell.identifier,
                                                              for: indexPath) as? SongListItemCell
    else { return .init() }

    cell.textLabel?.text = cellViewModel.titleText

    return cell
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellType = viewModel.songListCellTypes[indexPath.row]

    switch cellType {
    case .empty:
      return bindEmptyCell(tableView, cellForRowAt: indexPath)
    case .item(let cellViewModel):
      return bindItemCell(tableView, cellForRowAt: indexPath, cellViewModel: cellViewModel)
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch viewModel.songListCellTypes[indexPath.row] {
    case .item(let cellViewModel):
      viewModel.showSongDetail(cellViewModel.model)
    default: return
    }
  }
}


