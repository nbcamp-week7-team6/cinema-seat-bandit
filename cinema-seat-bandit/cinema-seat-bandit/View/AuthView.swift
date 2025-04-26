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

final class AuthView: UIView {
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력하세요."
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력하세요."
        return textField
    }()
    
    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        return label
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 다시 입력하세요."
        return textField
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
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViewForMode() {
        confirmPasswordLabel.isHidden = mode == .login
        confirmPasswordTextField.isHidden = mode == .login
    }
    
    private func setupViews() {
        
    }
    
    private func setupConstraints() {
        
    }
}
