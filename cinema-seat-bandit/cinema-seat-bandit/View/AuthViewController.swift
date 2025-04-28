//
//  AuthViewController.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/26/25.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    private let authViewModel = AuthViewModel()
    private let authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindViewModel()
        setupActions()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        [authView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        authView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bindViewModel() {
        authViewModel.signupSuccess.bind { [weak self] isSuccess in
            guard let self else { return }
            
            if isSuccess {
                print("회원가입 성공")
                // 회원가입 이후 수행할 작업
            }
        }
        
        authViewModel.errorMessage.bind { [weak self] errorMessage in
            guard let self, let errorMessage else { return }
            
            print("회원가입 실패: \(errorMessage)")
            // 회원가입 실패 이후 수행할 작업
        }
    }
    
    private func setupActions() {
        authView.authActionButton.addTarget(self, action: #selector(authActionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func authActionButtonTapped() {
        let email = authView.emailTextField.text ?? ""
        let password = authView.confirmPasswordTextField.text ?? ""
        authViewModel.signup(email: email, password: password)
    }
}
