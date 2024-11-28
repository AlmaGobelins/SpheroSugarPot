//
//  ContentView.swift
//  SpheroSugarPot
//
//  Created by Mathieu Dubart on 28/11/2024.
//

import SwiftUI

struct ContentView: View {
    let spherosNames: [String] = ["SB-C7A8"]
    @State private var spheroIsConnected: Bool = false
    @StateObject private var videoController = VideoPlayerController()
    @State private var videoIsPlaying: Bool = false
    
    private let flipDetector = FlipDetector(toyBox: SharedToyBox.instance)
    
    var body: some View {
        VStack {
            SingleVideoPlayer(videoName: "test", format: "mov", frameSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), controller: videoController)
                .onAppear {
                    self.videoController.pause()
                }
        }
        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
        .onAppear {
            
            flipDetector.onFlipDetected = {
                if spheroIsConnected {
                    self.toggleVideoPlay()
                }
            }
            
            SharedToyBox.instance.searchForBoltsNamed(spherosNames) { err in
                if err == nil {
                    print("Connected to sphero")
                    self.spheroIsConnected.toggle()
                    flipDetector.startMonitoring()
                }
            }
        }
        .onDisappear {
            SharedToyBox.instance.stopSensors()
            flipDetector.stopMonitoring()
        }
        .padding()
    }
    
    func toggleVideoPlay() {
        if videoIsPlaying {
            self.videoController.pause()
            self.videoIsPlaying.toggle()
        }
        
        if !videoIsPlaying {
            self.videoController.play()
            self.videoIsPlaying.toggle()
        }
    }
}

#Preview {
    ContentView()
}
