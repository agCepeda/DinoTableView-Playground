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

    let dinoTableView = GridTableView()

    let columns = [
      ColumnModel(name: "lastName", width: 200.0, attributeKey: "lastName"),
      ColumnModel(name: "firstName", width: 100.0, attributeKey: "firstName"),
      ColumnModel(name: "age", width: 200.0, attributeKey: "age"),
      ColumnModel(name: "weight", width: 100.0, attributeKey: "weight"),
      ColumnModel(name: "height", width: 300.0, attributeKey: "height"),
      ColumnModel(name: "gender", width: 100.0, attributeKey: "gender"),
      ColumnModel(name: "savings", width: 300.0, attributeKey: "savings"),
    ]

    dinoTableView.dataProvider = StudentsDataSource()
    dinoTableView.columns = columns
    dinoTableView.headerRowHeight = 50.0
    dinoTableView.contentRowHeight = 70.0
    dinoTableView.stickyColumn = true
    dinoTableView.showHeader = false
    dinoTableView.stickyHeader = true

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

class StudentsDataSource: GridTableViewDataProvider {
  func getRowCount() -> Int {
    return 50
  }

  public func getRow(from index: Int) -> Dictionary<String, NSObject> {
    return Dictionary(dictionaryLiteral: ("firstName", "Juan Luis" as NSObject),
                                         ("lastName", "Lopez Perez" as NSObject),
                                         ("age", 19 as NSObject),
                                         ("weight", 72.5 as NSObject),
                                         ("savings", 71222.53123 as NSObject),
                                         ("gender", "Male" as NSObject))
  }
}
