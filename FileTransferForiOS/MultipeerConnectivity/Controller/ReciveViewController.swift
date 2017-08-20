//
//  ReciveViewController.swift
//  Connectivity
//
//  Created by William Lee on 20/8/17.
//
//

import UIKit
import MultipeerConnectivity

class ReciveViewController: UIViewController {
  
  fileprivate var userView: UIButton = UIButton(type: .custom)
  fileprivate var animationView: RippleAnimationView?
  fileprivate var timer: Timer?
  
  fileprivate let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
  fileprivate var session: MCSession?
  fileprivate var advertiser: MCNearbyServiceAdvertiser?
  fileprivate var browser: MCNearbyServiceBrowser?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setupView()
    self.scanNearbyPeer()
  }
  
  
}

// MARK: - Utility
fileprivate extension ReciveViewController {
  
  func scanNearbyPeer() {
    
    //创建会话
    self.session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    self.session?.delegate = self
    
    //发布广播
    self.advertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: "rsp-receiver")
    self.advertiser?.delegate = self
    self.advertiser?.startAdvertisingPeer()
    
    //收听广播
    self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: "rsp-sender")
    self.browser?.delegate = self
    self.browser?.startBrowsingForPeers()
  }
  
  func setupView() {
    
    self.navigationItem.title = "接收文件"
    self.view.backgroundColor = UIColor.white
    
    self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loopAnimation(_:)), userInfo: nil, repeats: true)
  
    self.userView.frame = CGRect(x: 0, y: 64, width: 320, height: 50)
    self.userView.setTitle("未发现", for: .normal)
    self.userView.setTitleColor(UIColor.purple, for: .normal)
    self.view.addSubview(self.userView)
  }
  
  @objc func loopAnimation(_ timer: Timer) {
    
    let width = UIScreen.main.bounds.width - 60
    let animationView = RippleAnimationView(frame: CGRect(x: 30, y: 150, width: width, height: width))
    self.view.addSubview(animationView)
    self.animationView = animationView
    UIView.animate(withDuration: 2, animations: {
      
      animationView.transform = CGAffineTransform(scaleX: 4, y: 4)
      animationView.alpha = 0
      
    }, completion: { (finished) in
      
      animationView.removeFromSuperview()
      
    })
    
  }
  
}

// MARK: - MCSessionDelegate
extension ReciveViewController: MCSessionDelegate {
  
  // 会话状态改变回调
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    
    switch state {
    case .connecting:
      
      print("连接中")
      
    case .connected:
      
      print("已连接")
      
    case .notConnected:
      
      print("未连接")
    }
  }
  
  // Type1:普通数据传输
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    
    print("接收来自：\(peerID.displayName)普通数据")
  }

  // Type2:数据流传输
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    
    print("接收来自：\(peerID.displayName)流数据")
  }
  
  // Type3:资源传输开始
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
   
    print("开始传输文件：\(resourceName)")
  }
  
  // Type3:资源传输完成
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
    
    if let error = error {
      
      print("接收来自\(peerID.displayName)的文件\(resourceName)发生异常，原因：\(error.localizedDescription)")
      return
    }
    
    guard let destinationPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/Book/\(resourceName)") else { return }
    if FileManager.default.isDeletableFile(atPath: destinationPath) {
      
      try? FileManager.default.removeItem(atPath: destinationPath)
    }
    let destinationURL = URL(fileURLWithPath: destinationPath)
    
    try? FileManager.default.moveItem(at: localURL, to: destinationURL)
    
    DispatchQueue.main.async {
      
      let alertController = UIAlertController(title: "提示", message: "接收\(resourceName)成功", preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .cancel) { (action) in
      
        self.navigationController?.popViewController(animated: true)
      }

      alertController.addAction(action)
      self.present(alertController, animated: true) { }
      
    }
  }
  
  func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
    
    print("进行验证连接")
    certificateHandler(true)
  }
  
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension ReciveViewController: MCNearbyServiceAdvertiserDelegate {
  
  // 收到节点邀请回调
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    
    print("收到\(peerID.displayName)的连接邀请")
    
    let alertController = UIAlertController(title: "提示", message: "\(peerID.displayName)想进行连接", preferredStyle: .alert)
    let refuseAction = UIAlertAction(title: "拒绝", style: .default) { (action) in
      
      invitationHandler(false, self.session)
    }
    let acceptAction = UIAlertAction(title: "接受", style: .default) { (action) in
      
      invitationHandler(true, self.session)
      advertiser.stopAdvertisingPeer()
    }
    alertController.addAction(refuseAction)
    alertController.addAction(acceptAction)
    self.present(alertController, animated: true) { }
    
  }

  // 广播失败
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
    
    advertiser.stopAdvertisingPeer()
    print("\(advertiser.myPeerID.displayName)")
    
  }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension ReciveViewController: MCNearbyServiceBrowserDelegate {
  
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    
    print("发现节点：\(peerID.displayName)")
    self.userView.setTitle(peerID.displayName, for: .normal)
    
  }

  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    
    print("丢失节点：\(peerID.displayName)")
    self.userView.setTitle("未发现", for: .normal)
    browser.startBrowsingForPeers()
    
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
   
    print("搜索节点失败，原因：\(error.localizedDescription)")
    browser.stopBrowsingForPeers()
  }
  
}















