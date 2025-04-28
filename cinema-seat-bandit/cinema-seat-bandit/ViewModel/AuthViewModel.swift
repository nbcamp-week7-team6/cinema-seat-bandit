//
//  AuthViewModel.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/28/25.
//

import Foundation
import FirebaseAuth

final class AuthViewModel {
    let signupSuccess = Observable<Bool>(false)
    let errorMessage = Observable<String?>(nil)
    
    func signup(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error {
                self?.signupSuccess.value = false
                self?.errorMessage.value = error.localizedDescription
            } else {
                self?.signupSuccess.value = true
                self?.errorMessage.value = nil
            }
        }
    }
}
