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
        setupTextFieldActions()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(authView)
    }
    
    private func setupConstraints() {
        authView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func bindViewModel() {
        viewModel.isEmailValid.bind { [weak self] isValid in
            guard let self else { return }
            
            let isEmpty = self.authView.emailTextField.text?.isEmpty ?? true
            self.authView.emailValidationLabel.isHidden = isValid || isEmpty
            self.authView.emailValidationLabel.text = isValid ? nil : "올바른 이메일 형식이 아닙니다."
        }
        
        viewModel.isPasswordValid.bind { [weak self] isValid in
            guard let self else { return }
            
            let isEmpty = self.authView.passwordValidationLabel.text?.isEmpty ?? true
            self.authView.passwordValidationLabel.isHidden = isValid || isEmpty
            self.authView.passwordValidationLabel.text = isValid ? nil : "비밀번호는 8자 이상이어야 합니다."
        }
        
        viewModel.isPasswordMatch.bind { [weak self] isMatch in
            guard let self else { return }
            
            let isEmpty = self.authView.confirmPasswordValidationLabel.text?.isEmpty ?? true
            self.authView.confirmPasswordValidationLabel.isHidden = isMatch || isEmpty
            self.authView.confirmPasswordValidationLabel.text = isMatch ? nil : "비밀번호가 일치하지 않습니다."
        }
        
        viewModel.isFormValid.bind { [weak self] isValid in
            self?.authView.authActionButton.isEnabled = isValid
            self?.authView.authActionButton.alpha = isValid ? 1.0 : 0.1
        }
        
        viewModel.signupSuccess.bind { [weak self] isSuccess in
            guard let self else { return }
            
            if isSuccess {
                self.showSignupCompleteAlert()
            }
        }
        
        viewModel.loginSuccess.bind { [weak self] isSuccess in
            guard let self else { return }
            
            if isSuccess {
                self.moveToTabBar()
            }
        }
        
        viewModel.errorMessage.bind { [weak self] authError in
            guard let self, let authError else { return }
            
            let (type, message) = authError
            
            let title = type == .signup ? "회원가입 실패" : "로그인 실패"
            self.showErrorAlert(title: title, message: message)
        }
    }
    
    private func setupActions() {
        authView.authActionButton.addTarget(self, action: #selector(authActionButtonTapped), for: .touchUpInside)
        authView.authSwitchButton.addTarget(self, action: #selector(authSwitchButtonTapped), for: .touchUpInside)
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
    
    @objc private func authSwitchButtonTapped() {
        if authView.mode == .login {
            authView.mode = .signup
            viewModel.updateMode(.signup)
        } else {
            authView.mode = .login
            viewModel.updateMode(.login)
        }
    }
    
    private func setupTextFieldActions() {
        [
            authView.emailTextField,
            authView.passwordTextField,
            authView.confirmPasswordTextField
        ].forEach {
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    @objc private func textFieldDidChange(_ sender: UITextField) {
        let email = authView.emailTextField.text ?? ""
        let password = authView.passwordTextField.text ?? ""
        let confirmPassword = authView.confirmPasswordTextField.text ?? ""
        
        switch sender {
        case authView.emailTextField:
            viewModel.validateEmail(email)
        case authView.passwordTextField:
            viewModel.validatePassword(password)
            if authView.mode == .signup {
                viewModel.validatePasswordMatch(password, confirmPassword)
            }
        case authView.confirmPasswordTextField:
            viewModel.validatePasswordMatch(password, confirmPassword)
        default:
            break
        }
        
        viewModel.updateFormValidation()
    }
    
    private func showSignupCompleteAlert() {
        let alert = UIAlertController(title: "회원가입 완료", message: "로그인 후 이용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.switchToLoginMode()
        }))
        present(alert, animated: true)
    }
    
    private func switchToLoginMode() {
        authView.mode = .login
        viewModel.updateMode(.login)
        
        authView.passwordTextField.text = ""
        authView.confirmPasswordTextField.text = ""
    }
    
    private func moveToTabBar() {
        let tabBarController = TabBarController()
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
           let window = (sceneDelegate as? NSObject)?.value(forKey: "window") as? UIWindow {
            
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
