import SwiftUI
import AVKit

struct VideoFeedView: View {
    @StateObject private var viewModel = VideoFeedViewModel()
    @State private var currentIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            TabView(selection: $currentIndex) {
                ForEach(viewModel.videos.indices, id: \.self) { index in
                    VideoPlayerView(video: viewModel.videos[index])
                        .rotationEffect(.degrees(-90))
                        .frame(
                            width: geometry.size.height,
                            height: geometry.size.width
                        )
                        .tag(index)
                }
            }
            .frame(
                width: geometry.size.height,
                height: geometry.size.width
            )
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: geometry.size.width)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.fetchVideos()
        }
    }
}

struct VideoPlayerView: View {
    let video: Video
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ZStack {
            if let player = player {
                VideoPlayer(player: player)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(video.title)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(video.description)
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            isPlaying.toggle()
                            if isPlaying {
                                player?.play()
                            } else {
                                player?.pause()
                            }
                        }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {
                            // TODO: Implement share functionality
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 32, height: 40)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing)
                }
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
    
    private func setupPlayer() {
        guard let url = URL(string: video.videoURL) else { return }
        let player = AVPlayer(url: url)
        self.player = player
        
        // Loop video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}
