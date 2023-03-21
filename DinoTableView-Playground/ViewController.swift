//
//  ViewController.swift
//  DinoTableView Playground
//
//  Created by Agustin Cepeda on 24/02/23.
//

import UIKit
import DinoViews

struct StudentRecordModel {
  var firstName: String
  var lastName: String
}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    let dinoTableView = DinoTableView()

    let columns = [
      ColumnModel(name: "Columna 1", width: 200.0),
      ColumnModel(name: "Columna 2", width: 100.0),
      ColumnModel(name: "Columna 3", width: 200.0),
      ColumnModel(name: "Columna 4", width: 100.0),
      ColumnModel(name: "Columna 5", width: 300.0),
      ColumnModel(name: "Columna 1", width: 100.0),
      ColumnModel(name: "Columna 2", width: 100.0),
      ColumnModel(name: "Columna 3", width: 100.0),
      ColumnModel(name: "Columna 4", width: 100.0),
      ColumnModel(name: "Columna 5", width: 100.0),
      ColumnModel(name: "Columna 1", width: 100.0),
      ColumnModel(name: "Columna 2", width: 100.0),
      ColumnModel(name: "Columna 3", width: 100.0),
      ColumnModel(name: "Columna 4", width: 100.0),
      ColumnModel(name: "Columna 5", width: 100.0),
    ]


    dinoTableView.dataSource = self
    dinoTableView.layoutSettings = Settings(columns: columns,
                                                  headerRowHeight: 50.0,
                                                  contentRowHeight: 50.0,
                                                  stickyHeader: true,
                                                  stickyColumn: true)

    dinoTableView.frame = self.view.frame
    dinoTableView.translatesAutoresizingMaskIntoConstraints = false

    self.view.addSubview(dinoTableView)
    NSLayoutConstraint.activate([
      dinoTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
      dinoTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
      dinoTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
      dinoTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

}

extension ViewController: DinoTableViewDataSource {

  public func getRowCount() -> Int {
    return 50
  }

  public func getRow(from index: Int) -> RowModel {
    return RowModel()
  }
}

extension ViewController: DinoTableViewDelegate {}
