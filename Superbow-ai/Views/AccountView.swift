import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Profile Section
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(Auth.auth().currentUser?.email ?? "")
                                .font(.headline)
                            Text("NFL Fan")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Settings Section
                Section("Settings") {
                    NavigationLink(destination: Text("Notifications Settings")) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .frame(width: 25)
                            Text("Notifications")
                        }
                    }
                    
                    NavigationLink(destination: Text("Privacy Settings")) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .frame(width: 25)
                            Text("Privacy")
                        }
                    }
                    
                    NavigationLink(destination: Text("Help Center")) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .frame(width: 25)
                            Text("Help")
                        }
                    }
                }
                
                // App Info Section
                Section("App Info") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .frame(width: 25)
                        Text("Version 1.0.0")
                    }
                    
                    HStack {
                        Image(systemName: "doc.text.fill")
                            .frame(width: 25)
                        Text("Terms of Service")
                    }
                    
                    HStack {
                        Image(systemName: "hand.raised.fill")
                            .frame(width: 25)
                        Text("Privacy Policy")
                    }
                }
                
                // Sign Out Section
                Section {
                    Button(action: {
                        showingSignOutAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Sign Out")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Account")
            .alert(isPresented: $showingSignOutAlert) {
                Alert(
                    title: Text("Sign Out"),
                    message: Text("Are you sure you want to sign out?"),
                    primaryButton: .destructive(Text("Sign Out")) {
                        authViewModel.signOut()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
