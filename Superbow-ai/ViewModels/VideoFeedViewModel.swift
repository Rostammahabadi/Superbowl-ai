import Foundation
import FirebaseFirestore

struct Video: Identifiable {
    let id: String
    let title: String
    let description: String
    let videoURL: String
    let timestamp: Date
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.videoURL = data["videoURL"] as? String ?? ""
        self.timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
    }
}

class VideoFeedViewModel: ObservableObject {
    @Published var videos: [Video] = []
    private let db = Firestore.firestore()
    
    func fetchVideos() {
        db.collection("videos")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching videos: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self?.videos = documents.map { document in
                    Video(id: document.documentID, data: document.data())
                }
            }
    }
}
