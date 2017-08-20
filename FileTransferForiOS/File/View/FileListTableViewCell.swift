//
//  FileListTableViewCell.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import UIKit

class FileListTableViewCell: UITableViewCell {
  
  fileprivate let titleLabel: UILabel = UILabel()
  fileprivate let subtitleLabel: UILabel = UILabel()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    self.setupView()
    self.setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension FileListTableViewCell {
  
  func setup(with item: FileListItem) {
    
    self.titleLabel.text = item.title
    self.subtitleLabel.text = item.url?.absoluteString
  }
  
}

// MARK: - Setup
fileprivate extension FileListTableViewCell {
  
  func setupView() {
    
    self.titleLabel.numberOfLines = 0
    self.subtitleLabel.numberOfLines = 0
    
    self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.subtitleLabel)
    
  }
  
  func setupLayout() {
    
    self.titleLabel.wm_addConstraints { (make) in
      
      make.top(13).equal(self.contentView).top()
      make.leading(13).equal(self.contentView).leading()
      make.trailing(-13).equal(self.contentView).trailing()
    }
    
    self.subtitleLabel.wm_addConstraints { (make) in
      
      make.top(5).equal(self.titleLabel).bottom()
      make.leading().equal(self.titleLabel).leading()
      make.trailing().equal(self.titleLabel).trailing()
      make.bottom(-13).equal(self.contentView).bottom()
    }
  }
  
}










