//
//  PlaybackViewController.swift
//  Movie Killer
//
//  Created by Ronald Martin on 12/31/16.
//  Copyright © 2016 Ronald Martin. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer
import ReSwift

class PlaybackViewController: AVPlayerViewController {
    
    private let viewModel = PlaybackViewModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.player = player
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onStopPlayback()
    }
}


// MARK: - Presenter
fileprivate class PlaybackViewModel {
    
    // MARK: Properties
    
    weak var player: AVPlayer? {
        didSet {
            createPlaybackObserver(for: player)
            registerStopObserver(for: player)
        }
    }
    
    private var playerTimeObserverToken: Any?
    
    // MARK: - Lifecycle
    
    init() {
        store.subscribe(self) { state in state.playback }
    }
    
    deinit {
        removePlaybackObserver()
        removeStopObserver()
        store.unsubscribe(self)
    }
    
    // MARK: - Helpers
    
    // MARK: Playback elapsed observer
    
    private func createPlaybackObserver(for player: AVPlayer?) {
        removePlaybackObserver()
        
        let everySecond = CMTime(value: 1, timescale: 1)
        let observerQueue = DispatchQueue.global(qos: .userInteractive)
        
        playerTimeObserverToken = player?
            .addPeriodicTimeObserver(forInterval: everySecond,
                                     queue: observerQueue) { _ in
            store.dispatch(PlaybackAction.playbackElapsed(1))
        }
    }
    
    private func removePlaybackObserver() {
        if let playerTimeObserverToken = playerTimeObserverToken {
            player?.removeTimeObserver(playerTimeObserverToken)
            self.playerTimeObserverToken = nil
        }
    }
    
    // MARK: Playback stopped observer
    
    private func registerStopObserver(for player: AVPlayer?) {
        removeStopObserver()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerStopped(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    private func removeStopObserver() {
        NotificationCenter.default
            .removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc
    private func playerStopped(notification: NSNotification) {
        onStopPlayback()
    }
    
    func onStopPlayback() {
        store.dispatch(PlaybackAction.stopPlayback)
    }
}


// MARK: - Store subscriber
extension PlaybackViewModel: StoreSubscriber {
    
    fileprivate func newState(state: PlaybackState) {
        if state.timeUntilCrash <= 0 {
            store.dispatch(PlaybackAction.crashPlayback)
        }
    }
}
