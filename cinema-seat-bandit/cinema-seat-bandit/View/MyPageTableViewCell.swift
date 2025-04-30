//
//  MyPageTableViewCell.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/29/25.
//

import UIKit
import SnapKit

final class MyPageTableViewCell: UITableViewCell {
    static let identifier = "MyPageTableViewCell"
    
    private let reservationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray2
        return label
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("영화상세", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .regular)
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 9
        button.layer.masksToBounds = true
        return button
    }()
    
    private let reservationInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let theaterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let movieInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 8
        return sv
    }()
    
    private let posterInfoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.alignment = .center
        return sv
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [
            reservationDateLabel,
            detailButton
        ].forEach { reservationInfoStackView.addArrangedSubview($0) }

        [
            movieTitleLabel,
            theaterNameLabel
        ].forEach { movieInfoStackView.addArrangedSubview($0) }

        [
            posterImageView,
            movieInfoStackView
        ].forEach { posterInfoStackView.addArrangedSubview($0) }

        [
            reservationInfoStackView,
            posterInfoStackView
        ].forEach { containerView.addSubview($0) }

        contentView.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
        }
        
        detailButton.snp.makeConstraints {
            $0.width.equalTo(54)
            $0.height.equalTo(18)
        }
        
        reservationInfoStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        posterInfoStackView.snp.makeConstraints {
            $0.top.equalTo(reservationInfoStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with reservation: Reservation) {
        reservationDateLabel.text = reservation.reservationDate
        theaterNameLabel.text = reservation.theaterName
        movieTitleLabel.text = reservation.movieTitle
    }
}
