//
//  AuthView.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/26/25.
//

import UIKit
import SnapKit

enum AuthMode {
    case login
    case signup
}

final class PaddedTextField: UITextField {
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

final class AuthView: UIView {
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "이메일을 입력하세요."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "비밀번호를 입력하세요."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        return label
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = PaddedTextField()
        textField.placeholder = "비밀번호를 다시 입력하세요."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let confirmPasswordStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    private let authActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let authSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 회원이 아니신가요?"
        return label
    }()
    
    private let authSwitchButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    private let authSwitchStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    
    var mode: AuthMode = .login {
        didSet {
            updateViewForMode()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        updateViewForMode()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViewForMode() {
        confirmPasswordLabel.isHidden = mode == .login
        confirmPasswordTextField.isHidden = mode == .login
        authActionButton.setTitle(mode == .login ? "로그인" : "회원가입", for: .normal)        
        authSwitchLabel.text = mode == .login ? "아직 회원이 아니신가요?" : "이미 계정이 있으신가요?"
        authSwitchButton.setTitle(mode == .login ? "회원가입" : "로그인", for: .normal)
    }
    
    private func setupViews() {
        [
            confirmPasswordLabel,
            confirmPasswordTextField,
        ].forEach { confirmPasswordStackView.addArrangedSubview($0) }
        
        [
            authSwitchLabel,
            authSwitchButton
        ].forEach { authSwitchStackView.addArrangedSubview($0) }
        
        [
            emailLabel,
            emailTextField,
            passwordLabel,
            passwordTextField,
            confirmPasswordStackView,
            authActionButton,
            authSwitchStackView
        ].forEach { addSubview($0) }
        
        authSwitchButton.addTarget(self, action: #selector(authSwitchButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        confirmPasswordStackView.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        
        authActionButton.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        authSwitchStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc private func authSwitchButtonTapped() {
        mode == .login ? (mode = .signup) : (mode = .login)
    }
}
