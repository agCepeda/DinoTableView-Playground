//
//  ViewController.swift
//  DinoTableView Playground
//
//  Created by Agustin Cepeda on 24/02/23.
//

import UIKit
import DinoViews

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
    dinoTableView.layoutSettings = LayoutSettings(columns: columns, headerRowHeight: 50.0, contentRowHeight: 50.0)
    dinoTableView.frame = self.view.frame
    dinoTableView.translatesAutoresizingMaskIntoConstraints = true

    self.view.addSubview(dinoTableView)

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