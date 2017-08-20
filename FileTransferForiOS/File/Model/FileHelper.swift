//
//  FileHelper.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import Foundation

class FileHelper {
  
  
  
}

extension FileHelper {
  
  class func bookPaths() -> [URL] {
    
    guard let directory = try? FileHelper.bookDirectory() else { return [] }
    
    guard let fileNames = FileManager.default.subpaths(atPath: directory) else { return [] }
    
    return fileNames.map { URL(fileURLWithPath: directory.appending("/\($0)")) }
  }
  
}

fileprivate extension FileHelper {
  
  enum State: Error {
    
    case success
    case failture(String)
  }
  
  class func bookDirectory() throws -> String {
    
    //获取Book文件夹路径
    guard let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/Book") else {
      
      throw State.failture("无法获取BookDirectory")
    }
    
    //无此文件夹则创建该文件夹
    if !FileManager.default.fileExists(atPath: directory) {
      
      do {
        
        try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: [URLResourceKey.isExcludedFromBackupKey.rawValue : true])
        
      } catch {
        
        throw State.failture(error.localizedDescription)
        
      }
      
    }
    
    return directory
  }
  
}
