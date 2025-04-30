//
//  Untitled.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit
import Kingfisher

final class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"

    private let imageView: UIImageView = {
        let imagView = UIImageView()
        imagView.contentMode = .scaleAspectFill
        imagView.clipsToBounds = true
        imagView.layer.cornerRadius = 8
        imagView.backgroundColor = .lightGray
        return imagView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemYellow
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)

        imageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(180)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }
        ratingLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        ratingLabel.text = "⭐️ \(String(format: "%.1f", movie.vote_average))"

        if let posterPath = movie.poster_path {
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
    }
}

