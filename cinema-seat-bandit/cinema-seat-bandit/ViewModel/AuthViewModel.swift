//
//  AuthViewModel.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/28/25.
//

import Foundation
import FirebaseAuth

enum AuthErrorType {
    case signup
    case login
}

final class AuthViewModel {
    var mode: AuthMode = .login
    
    let isEmailValid = Observable<Bool>(false)
    let isPasswordValid = Observable<Bool>(false)
    let isPasswordMatch = Observable<Bool>(false)
    let isFormValid = Observable<Bool>(false)
    
    let signupSuccess = Observable<Bool>(false)
    let loginSuccess = Observable<Bool>(false)
    let errorMessage = Observable<(AuthErrorType, String)?>(nil)
    
    func validateEmail(_ email: String) {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let prediction = NSPredicate(format: "SELF MATCHES %@", emailReg)
        isEmailValid.value = prediction.evaluate(with: email)
        updateFormValidation()
    }
    
    func validatePassword(_ password: String) {
        isPasswordValid.value = password.count >= 8
    }
    
    func validatePasswordMatch(_ password: String, _ confirmPassword: String) {
        guard !confirmPassword.isEmpty else {
            isPasswordMatch.value = false
            return
        }
        
        isPasswordMatch.value = password == confirmPassword
    }
    
    func updateFormValidation() {
        switch mode {
        case .login:
            isFormValid.value = isEmailValid.value && isPasswordValid.value
        case .signup:
            isFormValid.value = isEmailValid.value && isPasswordValid.value && isPasswordMatch.value
        }
    }
    
    func updateMode(_ mode: AuthMode) {
        self.mode = mode
        updateFormValidation()
    }
    
    func signup(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.signupSuccess.value = false
                self?.errorMessage.value = (.signup, error.localizedDescription)
            } else {
                self?.signupSuccess.value = true
                self?.errorMessage.value = nil
            }
        }
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.loginSuccess.value = false
                self?.errorMessage.value = (.login, error.localizedDescription)
            } else {
                self?.loginSuccess.value = true
                self?.errorMessage.value = nil
            }
        }
    }
}
