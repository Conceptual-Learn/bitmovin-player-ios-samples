//
// Bitmovin Player iOS SDK
// Copyright (C) 2017, Bitmovin GmbH, All Rights Reserved
//
// This source code and its use and distribution, is subject to the terms
// and conditions of the applicable license agreement.
//

import UIKit
import BitmovinPlayer

final class ViewController: UIViewController {

    var player: BitmovinPlayer?

    deinit {
        player?.destroy()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black

        // Define needed resources
        guard let streamUrl = URL(string: "https://bitmovin-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8") else {
            return
        }

        // Create player configuration
        let config = PlayerConfiguration()

        /**
         * TODO: Add URLs below to make this sample application work.
         * Go to https://github.com/bitmovin/bitmovin-player-ui to get started with creating a custom player UI.
         */
        guard let cssURL = URL(string: ""),
              let jsURL = URL(string: "") else {
            print("Please specify the needed resources marked with TODO in ViewController.swift file.")
            return
        }
        config.styleConfiguration.playerUiCss = cssURL
        config.styleConfiguration.playerUiJs = jsURL

        do {
            try config.setSourceItem(url: streamUrl)

            // Create player based on player configuration
            let player = BitmovinPlayer(configuration: config)

            // Create player view and pass the player instance to it
            let playerView = BMPBitmovinPlayerView(player: player, frame: .zero)

            playerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            playerView.frame = view.bounds

            view.addSubview(playerView)
            view.bringSubview(toFront: playerView)

            self.player = player
        } catch {
            print("Configuration error: \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        // Add ViewController as event listener
        player?.add(listener: self)
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Remove ViewController as event listener
        player?.remove(listener: self)
        super.viewWillDisappear(animated)
    }
}

extension ViewController: PlayerListener {

    func onPlay(_ event: PlayEvent) {
        print("onPlay \(event.time)")
    }

    func onPaused(_ event: PausedEvent) {
        print("onPaused \(event.time)")
    }

    func onTimeChanged(_ event: TimeChangedEvent) {
        print("onTimeChanged \(event.currentTime)")
    }

    func onDurationChanged(_ event: DurationChangedEvent) {
        print("onDurationChanged \(event.duration)")
    }

    func onError(_ event: ErrorEvent) {
        print("onError \(event.message)")
    }
}
