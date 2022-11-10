//
//  ConnectionManager.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 06.11.2022.
//

import MultipeerConnectivity

protocol ConnectionProtocol {
    func connected()
}

protocol PeerRecieveDelegate {
    func disconnected()
    func recieved(message: MessageType)
}

class ConnectionManager:NSObject{
    
    private var mcSession: MCSession?
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    private var serviceBrowser: MCNearbyServiceBrowser
    var mcBrowserVC: MCBrowserViewController?
    var parentVC: StartGameViewController?
    var connectionDelegate: ConnectionProtocol?
    var recieveDelegate: PeerRecieveDelegate?
    
    
    override init() {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "ba-td")
        serviceBrowser = MCNearbyServiceBrowser(peer: peerID, serviceType: "ba-td")
        super.init()
        self.setUpConnectivity()
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    func setUpConnectivity() {
        if mcSession != nil {
            mcSession?.disconnect()
        }
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        mcSession?.delegate = self
    }
    
    func presentMCBrowser(from vc: StartGameViewController) {
        guard let mcSession = mcSession else {return}
        parentVC = vc
        serviceBrowser.startBrowsingForPeers()
        mcBrowserVC = MCBrowserViewController(browser: serviceBrowser, session: mcSession)
        mcBrowserVC!.delegate = self
        mcBrowserVC!.minimumNumberOfPeers = 2
        mcBrowserVC!.maximumNumberOfPeers = 2
        mcBrowserVC!.modalTransitionStyle = .coverVertical
        mcBrowserVC!.modalPresentationStyle = .overFullScreen
        vc.present(mcBrowserVC!, animated: true)
    }
    
    func send(message: MessageType) {
        guard let mcSession = mcSession else {return}

        do {
            guard let data = try? JSONEncoder().encode(message) else { return }
            try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
            print(error.localizedDescription)
        }
    }

    func disconnect() {
        if mcSession != nil {
            mcSession?.disconnect()
            mcSession == nil
        }
    }
    
    func startAdvertisingPeer(parentVC: StartGameViewController) {
        self.parentVC = parentVC
        serviceAdvertiser.startAdvertisingPeer()
    }
    
    func stopAvertisingPeer() {
        serviceAdvertiser.stopAdvertisingPeer()
    }
    
}

extension ConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("disconnectred")
//            recieveDelegate?.disconnected()
        case .connecting:
            print("connecting")
        case .connected:
            DispatchQueue.main.async {
                self.serviceAdvertiser.stopAdvertisingPeer()
                if let mcBrowser = self.mcBrowserVC {
                    self.browserViewControllerDidFinish(mcBrowser)
                }
               // self.conectedDelegate?.connected()
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            let message = try JSONDecoder().decode(MessageType.self, from: data)
            switch message {
            case .score(let score) :
                recieveDelegate?.recieved(message: .score(score))
            case .win(let isWin):
                recieveDelegate?.recieved(message: .win(isWin))
            default:
                return
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        return
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        return
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        return
    }
    
    
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let conectData = try? JSONDecoder().decode(MessageType.self, from: context!) else {return}
        switch conectData {
        case .conecting(let stake):
            if stake <= Defaults.coinsCount! {
                invitationHandler(true, mcSession)
                Defaults.stake = stake
                self.connectionDelegate?.connected()
            } else {
                parentVC?.showAlert()
                invitationHandler(false, mcSession)
            }
        default:
            invitationHandler(false, mcSession)
        }
        invitationHandler(true, mcSession)
    }
}

extension ConnectionManager: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        if let vc = UIApplication.getTopViewController() {
            vc.dismiss(animated: true) {
                self.connectionDelegate?.connected()
              //  self.conectedDelegate?.connected()
            }
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        if let vc = UIApplication.getTopViewController() {
            vc.dismiss(animated: true) {
//                self.conectedDelegate?.connected()
            }
        }
    }
}

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let mcSession = mcSession else {return}
        let stake = (parentVC == nil && parentVC?.stake != nil) ? 10 : parentVC!.stake!
        let model = MessageType.conecting(stake)
        guard let data = try? JSONEncoder().encode(model) else { return }
        browser.invitePeer(peerID, to: mcSession, withContext:data, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("lost peer")
    }
    
    
}

enum MessageType: Codable {
    case conecting(Int)
    case score(Int)
    case win(Bool)
    
}



