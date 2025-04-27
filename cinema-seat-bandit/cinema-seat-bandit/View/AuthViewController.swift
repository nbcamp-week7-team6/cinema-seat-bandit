//
//  AuthViewController.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/26/25.
//

import UIKit
import SnapKit

final class AuthViewController: UIViewController {
    private let authView = AuthView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
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
}
