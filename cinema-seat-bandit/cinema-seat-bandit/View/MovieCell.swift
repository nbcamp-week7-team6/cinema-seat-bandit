//
//  Untitled.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

final class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"

    private let imageView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
