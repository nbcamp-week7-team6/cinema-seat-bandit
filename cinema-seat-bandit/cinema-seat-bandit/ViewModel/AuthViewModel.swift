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
    let signupSuccess = Observable<Bool>(false)
    let loginSuccess = Observable<Bool>(false)
    let errorMessage = Observable<(AuthErrorType, String)?>(nil)
    
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
