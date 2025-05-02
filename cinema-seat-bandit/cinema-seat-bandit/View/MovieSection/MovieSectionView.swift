//
//  MovieSectionView.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

final class MovieSectionView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        return collectionView
    }()


    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        [titleLabel, collectionView]
            .forEach{ addSubview($0)}
    }


    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.right.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(260)
            $0.bottom.equalToSuperview()
        }
    }

    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(220)
            //주의 *heightDimension이 컬렉션뷰의 height와 동등하거나 이상이면 위아애로 움직이는 이슈가 있음
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered

        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 0, trailing: 16)

        section.visibleItemsInvalidationHandler = { (visibleItems, offset, environment) in
               let centerX = offset.x + environment.container.contentSize.width / 2
               for item in visibleItems {
                   let distanceFromCenter = abs(item.frame.midX - centerX)
                   let minScale: CGFloat = 0.8
                   let maxScale: CGFloat = 1.15
                   let totalDistance = environment.container.contentSize.width / 2
                   let distanceRatio = min(distanceFromCenter / totalDistance, 1)
                   let scale = maxScale - (maxScale - minScale) * distanceRatio

                   UIView.animate(withDuration: 0.3) {
                       item.transform = CGAffineTransform(scaleX: scale, y: scale)
                   }
               }
           }
        return UICollectionViewCompositionalLayout(section: section)
    }
}
