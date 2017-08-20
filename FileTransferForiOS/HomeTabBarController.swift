//
//  HomeTabBarController.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import UIKit

class HomeTabBarController: UITabBarController {
  
  let fileListController: FileListViewController = FileListViewController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.addCustom(self.fileListController, andTitle: "文件列表", andImage: "tabbar")
  }
  
}

fileprivate extension HomeTabBarController {
  
  func addCustom(_ controller: UIViewController, andTitle title: String, andImage image: String) {
    
    controller.tabBarItem = UITabBarItem(title: title, image: UIImage(named: image), selectedImage: UIImage(named: image)?.withRenderingMode(.alwaysOriginal))
    
    let navigationController = UINavigationController(rootViewController: controller)
    self.addChildViewController(navigationController)
    
  }
}




