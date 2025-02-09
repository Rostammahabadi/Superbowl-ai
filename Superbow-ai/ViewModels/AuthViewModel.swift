import Foundation
import Combine
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func setupAuthStateListener() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
            }
        }
    }
    
    func signIn() {
        guard validateEmail() else { return }
        guard validatePassword() else { return }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.showError(message: error.localizedDescription)
                    return
                }
                
                // Successfully signed in
                self?.isAuthenticated = true
            }
        }
    }
    
    func signUp() {
        guard validateEmail() else { return }
        guard validatePassword() else { return }
        guard validateConfirmPassword() else { return }
        
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.showError(message: error.localizedDescription)
                    return
                }
                
                // Successfully created user
                self?.isAuthenticated = true
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        guard !email.isEmpty else {
            showError(message: "Email cannot be empty")
            return false
        }
        
        guard emailPredicate.evaluate(with: email) else {
            showError(message: "Please enter a valid email address")
            return false
        }
        
        return true
    }
    
    private func validatePassword() -> Bool {
        guard !password.isEmpty else {
            showError(message: "Password cannot be empty")
            return false
        }
        
        guard password.count >= 8 else {
            showError(message: "Password must be at least 8 characters long")
            return false
        }
        
        return true
    }
    
    private func validateConfirmPassword() -> Bool {
        guard password == confirmPassword else {
            showError(message: "Passwords do not match")
            return false
        }
        
        return true
    }
    
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}
