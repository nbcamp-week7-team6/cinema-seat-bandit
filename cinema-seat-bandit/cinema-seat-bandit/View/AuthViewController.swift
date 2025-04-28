//
//  AuthViewController.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/26/25.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    private let viewModel = AuthViewModel()
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
        viewModel.signupSuccess.bind { [weak self] isSuccess in
            guard let self else { return }
            
            if isSuccess {
                print("회원가입 성공")
                // 회원가입 이후 수행할 작업
            }
        }
        
        viewModel.loginSuccess.bind { [weak self] isSuccess in
            guard let self else { return }
            
            if isSuccess {
                print("로그인 성공")
                // 로그인 이후 수행할 작업
            }
        }
        
        viewModel.errorMessage.bind { [weak self] authError in
            guard let self, let authError else { return }
            
            let (type, message) = authError
            
            switch type {
            case .signup:
                print("회원가입 실패: \(message)")
                // 회원가입 실패 이후 수행할 작업
            case .login:
                print("로그인 실패: \(message)")
            }
            
            
        }
    }
    
    private func setupActions() {
        authView.authActionButton.addTarget(self, action: #selector(authActionButtonTapped), for: .touchUpInside)
    }
    
    @objc private func authActionButtonTapped() {
        let email = authView.emailTextField.text ?? ""
        let password = authView.passwordTextField.text ?? ""
        let confirmPassword = authView.confirmPasswordTextField.text ?? ""
        
        switch authView.mode {
        case .signup:
            viewModel.signup(email: email, password: confirmPassword)
        case .login:
            viewModel.login(email: email, password: password)
        }
    }
}
