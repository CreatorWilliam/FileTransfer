//
//  FileListItem.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import Foundation

struct FileListItem {
  
  var title: String?
  var url: URL?
  
  init(_ url: URL) {
    
    self.title = url.lastPathComponent.removingPercentEncoding
    self.url = url
  }
}
