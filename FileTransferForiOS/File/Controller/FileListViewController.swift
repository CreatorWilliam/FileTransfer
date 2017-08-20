//
//  FileListViewController.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import UIKit
import WMLayoutKit

class FileListViewController: UIViewController {
  
  fileprivate let tableView: UITableView = UITableView(frame: .zero, style: .grouped)
  
  fileprivate var list: [FileListItem] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupLayout()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.list = FileHelper.bookPaths().map({ FileListItem($0) })
    self.tableView.reloadData()
  }
  
}

// MARK: - Action
fileprivate extension FileListViewController {
  
  @objc func tapAdd(_ sender: UIBarButtonItem) {
    
    let viewController = ReciveViewController()
    viewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(viewController, animated: true)
    
  }
  
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FileListViewController: UITableViewDelegate, UITableViewDataSource {
  
  enum ReuseID: String {
    
    case cell = "FileListTableViewCell"
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let viewController = SendViewController()
    viewController.fileItem = self.list[indexPath.section]
    viewController.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
    return 5
  }
  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    
    return 0.01
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    return self.list.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: ReuseID.cell.rawValue, for: indexPath)
    
    if let cell = cell as? FileListTableViewCell {
      
      cell.setup(with: self.list[indexPath.section])
    }

    return cell
  }
  
}

// MARK: - Setup
fileprivate extension FileListViewController {
  
  func setupView() {
    
    self.automaticallyAdjustsScrollViewInsets = false
    self.navigationItem.title = "文件列表"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAdd(_:)))
    
    //TableView
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.estimatedRowHeight = 50
    self.tableView.register(FileListTableViewCell.self, forCellReuseIdentifier: ReuseID.cell.rawValue)
    self.view.addSubview(self.tableView)
  }
  
  func setupLayout() {
    
    self.tableView.wm_addConstraints { (make) in
      
      make.top().equal(self.topLayoutGuide).bottom()
      make.bottom().equal(self.bottomLayoutGuide).top()
      make.leading().equal(self.view).leading()
      make.trailing().equal(self.view).trailing()
    }
  }
  
}
