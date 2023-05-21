//
//  PlaybackPresenter.swift
//  Spotify
//
//  Created by Nazar Kopeyka on 02.05.2023.
//

import AVFoundation /* 1540 */
import Foundation
import UIKit /* 1379 */

protocol PlayerDataSource: AnyObject { /* 1503 */
    var songName: String? { get } /* 1504 */
    var subtitle: String? { get } /* 1505 */
    var imageURL: URL? { get } /* 1506 */
}

final class PlaybackPresenter { /* 1378 */
    static let shared = PlaybackPresenter() /* 1502 */
    
    private var track: AudioTrack? /* 1517 */
    private var tracks = [AudioTrack]() /* 1518 */
    
    var index = 0 /* 1631 */
    
    var currectTrack: AudioTrack? { /* 1519 */
        if let track = track, tracks.isEmpty { /* 1520 */
            return track /* 1521 */
        }
        else if let player = self.playerQueue, !tracks.isEmpty { /* 1522 */ /* 1610 add player */
//            let item = player.currentItem /* 1611 */
//            let items = player.items() /* 1612 */
//            guard let index = items.firstIndex(where: { $0 == item }) else { /* 1613 */
//                return nil /* 1614 */
//            }
            return tracks[index] /* 1523 */ /* 1615 change tracks.first */
        }
        
        return nil /* 1524 */
    }
    
    var playerVC: PlayerViewController? /* 1628 */
    
    var player: AVPlayer? /* 1541 */
    var playerQueue: AVQueuePlayer? /* 1590 */
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) { /* 1380 */
        guard let url = URL(string: track.preview_url ?? "") else { /* 1543 */
            return /* 1544 */
        }
        player = AVPlayer(url: url) /* 1542 */
        player?.volume = 0.3 /* 1547 */
        
        self.track = track /* 1527 */
        self.tracks = [] /* 1528 */
        let vc = PlayerViewController() /* 1384 */
        vc.title = track.name /* 1413 */
        vc.dataSource = self /* 1512 */
        vc.delegate = self /* 1556 */
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in /* 1385 */ /* 1411 add NavigationC*/ /* 1545 change completion: nil in and add weak self */
            self?.player?.play() /* 1546 */
        }
        self.playerVC = vc /* 1626 */
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack] /* 1382 add tracks */
    ) { /* 1381 */
        self.tracks = tracks /* 1525 */
        self.track = nil /* 1526 */
                
        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({ /* 1592 */
            guard let url = URL(string: $0.preview_url ?? "") else { /* 1593 */
                return nil /* 1594 */
            }
            return AVPlayerItem(url: url) /* 1595 */
        })) /* 1591 */
        self.playerQueue?.volume = 0.3 /* 1596 */
        self.playerQueue?.play() /* 1596 */
        
        let vc = PlayerViewController() /* 1400 */
        vc.dataSource = self /* 1588 */
        vc.delegate = self /* 1589 */
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil) /* 1401 */ /* 1412 add NavigationC*/
        self.playerVC = vc /* 1627 */
    }
 }

extension PlaybackPresenter: PlayerViewControllerDelegate { /* 1557 */
    func didTapPlayPause() { /* 1558 */
        if let player = player { /* 1561 */
            if player.timeControlStatus == .playing { /* 1562 */
                player.pause() /* 1563 */
            }
            else if player.timeControlStatus == .paused { /* 1564 */
                player.play() /* 1565 */
            }
        }
        else if let player = playerQueue { /* 1597 */
            if player.timeControlStatus == .playing { /* 1598 */
                player.pause() /* 1599 */
            }
            else if player.timeControlStatus == .paused { /* 1600 */
                player.play() /* 1601 */
            }
        }
    }
    
    func didTapForward() { /* 1559 */
        if tracks.isEmpty { /* 1566 */
            //Not album of playlist
            player?.pause() /* 1567 */
        }
        else if let player = playerQueue { /* 1568 */ /* 1602 add if let */
            player.advanceToNextItem() /* 1605 */
            index += 1 /* 1632 */
//            print(index) /* 1633 */
            playerVC?.refreshUI() /* 1629 */
        }
    }
    
    func didTapBackward() { /* 1560 */
        if tracks.isEmpty { /* 1569 */
            //Not platlist or album
            player?.pause() /* 1570 */
            player?.play() /* 1571 */
        }
        else if let firstItem = playerQueue?.items().first { /* 1572 */ /* 1604 add if let */
            playerQueue?.pause() /* 1603 */
            playerQueue?.removeAllItems() /* 1606 */
            playerQueue = AVQueuePlayer(items: [firstItem]) /* 1607 */
            playerQueue?.play() /* 1608 */
            playerQueue?.volume = 0.3 /* 1609 */
        }
    }
    
    func didSlideSlider(_ value: Float) { /* 1586 */
        player?.volume = value /* 1587 */
    }
}

extension PlaybackPresenter: PlayerDataSource { /* 1513 */
    var songName: String? { /* 1514 */
        return currectTrack?.name /* 1529 change nil */
    }
    
    var subtitle: String? { /* 1515 */
        return currectTrack?.artists.first?.name /* 1530 change nil */
    }
    
    var imageURL: URL? { /* 1516 */
//        print("Images: \(currectTrack?.album?.images.first)") /* 1616 */
        return URL(string: currectTrack?.album?.images.first?.url ?? "") /* 1531 change nil */
    }
    
}
