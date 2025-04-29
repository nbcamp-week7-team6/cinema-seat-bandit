//
//  MyPageView.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/29/25.
//

import UIKit
import SnapKit

final class MyPageView: UIView {
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 36
        iv.clipsToBounds = true
        return iv
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요. asdf@asdf.com"
        return label
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그아웃", for: .normal)
        return button
    }()
    
    private let userInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        return sv
    }()
    
    private let profileStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 16
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            userNameLabel,
            logoutButton
        ].forEach { userInfoStackView.addArrangedSubview($0) }
        
        [
            profileImageView,
            userInfoStackView
        ].forEach { profileStackView.addArrangedSubview($0) }
        
        [
            profileStackView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(72)
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
