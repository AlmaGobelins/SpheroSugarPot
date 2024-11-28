//
//  LoopingVideoView.swift
//  TAM Project
//
//  Created by Mathieu DUBART on 20/06/2024.
//

import SwiftUI
import AVKit

class VideoPlayerController: ObservableObject {
    private weak var playerViewController: PlayerViewController?
    
    func setPlayerViewController(_ controller: PlayerViewController) {
        self.playerViewController = controller
    }
    
    func play() {
        playerViewController?.playVideo()
    }
    
    func pause() {
        playerViewController?.pauseVideo()
    }
}

struct SingleVideoPlayer: View {
    var videoName: String
    var format: String
    var frameSize: CGSize
    @ObservedObject var controller: VideoPlayerController
    
    var body: some View {
        VideoPlayerRepresentable(
            videoName: videoName,
            format: format,
            frameSize: frameSize,
            controller: controller
        )
    }
    
    func play() {
        controller.play()
    }
    
    func pause() {
        controller.pause()
    }
}

struct VideoPlayerRepresentable: UIViewControllerRepresentable {
    var videoName: String
    var format: String
    var frameSize: CGSize
    var controller: VideoPlayerController
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = PlayerViewController(videoName: videoName, format: format, frameSize: frameSize)
        self.controller.setPlayerViewController(controller)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let playerViewController = uiViewController as? PlayerViewController {
            playerViewController.updateVideoSource(videoName: videoName, format: format, frameSize: frameSize)
        }
    }
}

