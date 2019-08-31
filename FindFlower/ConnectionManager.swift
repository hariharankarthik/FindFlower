//
//  ConnectionManager.swift
//  BlackJack
//
//  Created by Hari on 2019-08-11.
//  Copyright © 2019 Hariharan Karthikeyan. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ConnectionManagerDelegate {
    
    func connectedDevicesChanged(manager: ConnectionManager, connectedDevices: [String])
    
    func playTapReceived(manager: ConnectionManager, message: String)
    
}

protocol GamePlayDelegate { //Functions called during game play
    func gamePlayReceived(manager: ConnectionManager, message: String)
    
    func disconnectReceived(manager: ConnectionManager)
}

class ConnectionManager: NSObject {
    
    private let localPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    private let advertiser: MCNearbyServiceAdvertiser
    
    private let browser: MCNearbyServiceBrowser
    
    private let serviceType = "gesturegame-ios"
    
    static let connectionService = ConnectionManager()
    
    var connectionDelegate: ConnectionManagerDelegate?
    var gamePlayDelegate: GamePlayDelegate?
    
    lazy var session: MCSession = {
        
        let session = MCSession(peer: localPeerID, securityIdentity: nil, encryptionPreference: .none)
        
        session.delegate = self
        
        return session
    }()
    
    override init() {
        
        self.advertiser = MCNearbyServiceAdvertiser(peer: localPeerID, discoveryInfo: nil, serviceType: serviceType)
        
        self.browser = MCNearbyServiceBrowser(peer: localPeerID, serviceType: serviceType)
        
        super.init()
        
        self.advertiser.delegate = self
        
        self.browser.delegate = self
        
        stop()
        
    }
    
    public func start() {
        
        self.advertiser.startAdvertisingPeer()
        
        self.browser.startBrowsingForPeers()
        
    }
    
    public func stop() {
        
        self.advertiser.stopAdvertisingPeer()
        
        self.browser.stopBrowsingForPeers()
        
        self.session.disconnect()
        
    }
    
    deinit {
        stop()
    }
    
    func send(data: String) {
        print("Sent: \(data) to \(session.connectedPeers.count) peers")
        
        if (session.connectedPeers.count > 1) {
            print("Warning: Multiple peers found.")
        }
        if session.connectedPeers.count > 0 {
            do {
                try self.session.send(data.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
            }
            catch let error {
                print("MultipeerConnectivity: Error for sending: \(error)")
            }
        }
        
    }
    
}
extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
        
        func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
            
            invitationHandler(true, self.session)
            
        }
        
    }

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        browser.invitePeer(localPeerID, to: self.session, withContext: nil, timeout: 10)
        
        self.connectionDelegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        self.connectionDelegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    
}

extension ConnectionManager: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        self.connectionDelegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
        
        switch state {
        case MCSessionState.connected:
            print("MultipeerConnectivity: Connected: \(peerID.displayName)")
            break
            
        case MCSessionState.connecting:
            print("MultipeerConnectivity: Connecting: \(peerID.displayName)")
            break
            
        case MCSessionState.notConnected:
            print("MultipeerConnectivity: Not Connected: \(peerID.displayName)")
            break
        }
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("MultipeerConnectivity: didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        print("Message Received = \(str)")
        if (str == "slave") { //This means that you are a slave, show next game screen
            self.connectionDelegate?.playTapReceived(manager: self, message: str)
        } else { //GameViewController handles any other messages.
            self.gamePlayDelegate?.gamePlayReceived(manager: self, message: str)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("MultipeerConnectivity: didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("MultipeerConnectivity: didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("MultipeerConnectivity: didFinishReceivingResourceWithName")
    }
}

