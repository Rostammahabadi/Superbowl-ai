import SwiftUI
import Combine

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isSignUp = false
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.2, green: 0.2, blue: 0.3)]),
                          startPoint: .top,
                          endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) {
                    // Logo and Title
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                    
                    Text("NFL Plays")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                    
                    // Auth Form
                    VStack(spacing: 20) {
                        TextField("Email", text: $authViewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal)
                        
                        SecureField("Password", text: $authViewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textContentType(isSignUp ? .newPassword : .password)
                            .padding(.horizontal)
                        
                        if isSignUp {
                            SecureField("Confirm Password", text: $authViewModel.confirmPassword)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .textContentType(.newPassword)
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            if isSignUp {
                                authViewModel.signUp()
                            } else {
                                authViewModel.signIn()
                            }
                        }) {
                            Text(isSignUp ? "Sign Up" : "Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        Button(action: {
                            withAnimation {
                                isSignUp.toggle()
                            }
                        }) {
                            Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 30)
                }
                .padding()
            }
            
            if authViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $authViewModel.showError) {
            Alert(title: Text("Error"),
                  message: Text(authViewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthViewModel())
}
