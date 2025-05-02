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
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요. asdf@asdf.com"
        return label
    }()
    
    let logoutButton: UIButton = {
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
    
    private let tableViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "예매 내역"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let tableView = MyPageTableView()
    
    private let tableContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false

        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
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
        
        tableContainerView.addSubview(tableView)
        
        [
            profileStackView,
            tableViewTitleLabel,
            tableContainerView
        ].forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(72)
        }
        
        profileStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(112)
        }
        
        tableViewTitleLabel.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tableContainerView.snp.makeConstraints {
            $0.top.equalTo(tableViewTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
