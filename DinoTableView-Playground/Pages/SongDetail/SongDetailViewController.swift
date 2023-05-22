//
// Created by Agustin Cepeda on 28/04/23.
//

import UIKit


class SongClipCell: UITableViewCell {

  var viewModel: SongClipCellViewModel!

  var slider = ClipSelectorView()
  var playButton = UIButton()
  var lowerTimeLabel = UILabel()
  var upperTimeLabel = UILabel()

  override init(style: CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    setupView()
  }

  func setupView() {
    slider.onValueChanged = { lower, upper in

    }
    /*
    slider.addAction(UIAction { action in
      self.lowerTimeLabel.text = "\(self.slider.value)"
    }, for: .valueChanged)*/

    let rootStack = UIStackView(arrangedSubviews: [playButton, slider, lowerTimeLabel, upperTimeLabel])

    rootStack.axis = .vertical

    rootStack.translatesAutoresizingMaskIntoConstraints = false
    rootStack.backgroundColor = .purple

    playButton.setImage(UIImage.init(systemName: "play"), for: .normal)
    contentView.addSubview(rootStack)

    NSLayoutConstraint.activate([
      playButton.widthAnchor.constraint(equalToConstant: 50.0),
      playButton.heightAnchor.constraint(equalToConstant: 50.0),
      rootStack.heightAnchor.constraint(equalTo: contentView.heightAnchor),
      rootStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      rootStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      rootStack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
    ])
  }

  func bindViewModel(_ model: SongClipCellViewModel) {
    viewModel = model


    slider.minimumValue = 0
    slider.maximumValue = 100
    lowerTimeLabel.text = "0"
    upperTimeLabel.text = "\(model.clip.duration)"
  }
}

class SongDetailViewController: UITableViewController {

  var viewModel: SongDetailViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(SongClipCell.self, forCellReuseIdentifier: SongClipCell.identifier)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    setupNavigationBar()
    bind()
  }

  func setupNavigationBar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onLeftButtonTapped))
  }

  @objc func onLeftButtonTapped() {
    viewModel.addClip()
    tableView.reloadData()
  }

  func bind() {
    navigationItem.title = viewModel.titleText
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.clips.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: SongClipCell.identifier) as? SongClipCell
      else { return .init() }

    let cellViewModel = viewModel.clipViewModels[indexPath.row]
    cell.bindViewModel(cellViewModel)


    return cell
  }
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.layoutIfNeeded()
  }
}