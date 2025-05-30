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
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let defaultRect = super.rightViewRect(forBounds: bounds)
        return defaultRect.offsetBy(dx: -8, dy: 0)
    }
}

final class AuthView: UIView {
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    
    let emailTextField: UITextField = {
        let tf = PaddedTextField()
        tf.keyboardType = .emailAddress
        tf.placeholder = "이메일을 입력하세요."
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.layer.cornerRadius = 8
        tf.returnKeyType = .next
        return tf
    }()
    
    let emailValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    let passwordTextField: UITextField = {
        let tf = PaddedTextField()
        tf.placeholder = "비밀번호를 입력하세요."
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.layer.cornerRadius = 8
        tf.returnKeyType = .next
        return tf
    }()
    
    private let passwordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let passwordValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        return label
    }()
    
    let confirmPasswordTextField: UITextField = {
        let tf = PaddedTextField()
        tf.placeholder = "비밀번호를 다시 입력하세요."
        tf.borderStyle = .none
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray5.cgColor
        tf.layer.cornerRadius = 8
        tf.returnKeyType = .done
        return tf
    }()
    
    private let confirmPasswordToggleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    let confirmPasswordValidationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemRed
        label.isHidden = true
        return label
    }()
    
    let authActionButton: UIButton = {
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
    
    let authSwitchButton: UIButton = {
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
    
    var passwordFieldBottomAnchor: ConstraintItem?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        updateViewForMode()
        setupPasswordSecure()
        setupDelegates()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateViewForMode() {
        confirmPasswordLabel.isHidden = mode == .login
        confirmPasswordTextField.isHidden = mode == .login
        if mode == .login {
            confirmPasswordValidationLabel.isHidden = true
        } else {
            confirmPasswordValidationLabel.text = nil
            confirmPasswordValidationLabel.isHidden = true
        }
        
        let bottomAnchor = mode == .login ? passwordTextField.snp.bottom : confirmPasswordTextField.snp.bottom
        passwordFieldBottomAnchor = bottomAnchor
        
        authActionButton.setTitle(mode == .login ? "로그인" : "회원가입", for: .normal)
        authSwitchLabel.text = mode == .login ? "아직 회원이 아니신가요?" : "이미 계정이 있으신가요?"
        authSwitchButton.setTitle(mode == .login ? "회원가입" : "로그인", for: .normal)
        
        authActionButton.snp.remakeConstraints {
            $0.top.equalTo(bottomAnchor).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    private func setupViews() {
        [
            authSwitchLabel,
            authSwitchButton
        ].forEach { authSwitchStackView.addArrangedSubview($0) }
        
        [
            emailLabel,
            emailTextField,
            emailValidationLabel,
            passwordLabel,
            passwordTextField,
            passwordValidationLabel,
            confirmPasswordLabel,
            confirmPasswordTextField,
            confirmPasswordValidationLabel,
            authActionButton,
            authSwitchStackView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        emailLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        emailValidationLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview()
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        passwordValidationLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview()
        }
        
        confirmPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        confirmPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
        }
        
        confirmPasswordValidationLabel.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordTextField.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview()
        }
        
        if let bottomAnchor = passwordFieldBottomAnchor {
            authActionButton.snp.makeConstraints {
                $0.top.equalTo(bottomAnchor).offset(32)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(60)
            }
        }
        
        authSwitchStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupPasswordSecure() {
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        passwordTextField.rightView = passwordToggleButton
        passwordTextField.rightViewMode = .always
        confirmPasswordTextField.rightView = confirmPasswordToggleButton
        confirmPasswordTextField.rightViewMode = .always
        
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        confirmPasswordToggleButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func toggleConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry.toggle()
        let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        confirmPasswordToggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
}

extension AuthView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldBorders(selected: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldBorders(selected: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if mode == .signup {
                confirmPasswordTextField.becomeFirstResponder()
            } else {
                passwordTextField.resignFirstResponder()
            }
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func updateTextFieldBorders(selected: UITextField) {
        let fields = [emailTextField, passwordTextField, confirmPasswordTextField]
        for field in fields {
            field.layer.borderColor = (field == selected) ? UIColor.systemGray2.cgColor : UIColor.systemGray5.cgColor
        }
    }
}
