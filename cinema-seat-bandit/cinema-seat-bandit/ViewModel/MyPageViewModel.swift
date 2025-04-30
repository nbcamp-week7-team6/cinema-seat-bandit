//
//  MyPageViewModel.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/30/25.
//

import Foundation
import FirebaseAuth

final class MyPageViewModel: ViewModelProtocol {
    struct Input {
        let didLoadView: Observable<Void>
        let didTapLogout: Observable<Void?>
    }
    
    struct Output {
        let userEmail: Observable<String>
        let logoutSuccess: Observable<Bool>
    }
    
    private let email = Observable<String>("")
    private let logoutState = Observable<Bool>(false)
    
    func transform(input: Input) -> Output {
        input.didLoadView.bind { [weak self] _ in
            self?.fetchUserEmail()
        }
        
        input.didTapLogout.bind { [weak self] event in
            guard let _ = event else { return }
            self?.logout()
        }
        
        return Output(
            userEmail: email,
            logoutSuccess: logoutState
        )
    }
    
    private func fetchUserEmail() {
        if let email = Auth.auth().currentUser?.email {
            self.email.value = email
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            print("로그아웃 버튼 눌림")
            self.logoutState.value = true
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
}
