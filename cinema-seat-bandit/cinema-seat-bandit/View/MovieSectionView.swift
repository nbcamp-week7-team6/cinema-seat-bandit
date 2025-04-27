//
//  MovieSectionView.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

final class MovieSectionView: UIView {


    private let realMovies: [MovieModel] = [
        MovieModel(rank: 1, title: "Movie1", rating: 4.5),
        MovieModel(rank: 2, title: "Movie2", rating: 4.3),
        MovieModel(rank: 3, title: "Movie3", rating: 4.8),
        MovieModel(rank: 4, title: "Movie4", rating: 4.6),
        MovieModel(rank: 5, title: "Movie5", rating: 4.2)
    ]

    // 데이터를 반복해서 크게 만든다 (100배 정도)
    lazy var movies: [MovieModel] = Array(repeating: realMovies, count: 100).flatMap { $0 }


    func scrollToMiddle() {
        let middleIndexPath = IndexPath(item: movies.count / 2, section: 0)
        collectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
    }



    private let titleLabel = UILabel()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout()
        )

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .red
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.dataSource = self
        return collectionView
    }()

    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        setupViews()
        setupConstraints()

        //
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(collectionView)
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

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(240)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)

        section.visibleItemsInvalidationHandler = { (visibleItems, offset, environment) in
               let centerX = offset.x + environment.container.contentSize.width / 2
               for item in visibleItems {
                   let distanceFromCenter = abs(item.frame.midX - centerX)
                   let minScale: CGFloat = 0.8
                   let maxScale: CGFloat = 1.0
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

// MARK: - UICollectionViewDataSource

extension MovieSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

extension MovieSectionView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustCurrentIndexIfNeeded()
    }

    private func adjustCurrentIndexIfNeeded() {
        let visibleItems = collectionView.indexPathsForVisibleItems
        guard let currentIndex = visibleItems.sorted().first?.item else { return }

        let itemCount = movies.count
        let realItemCount = realMovies.count

        if currentIndex <= realItemCount {
            // 너무 앞으로 왔다
            let newIndex = itemCount / 2 + currentIndex
            let newIndexPath = IndexPath(item: newIndex, section: 0)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        } else if currentIndex >= itemCount - realItemCount {
            // 너무 뒤로 갔다
            let newIndex = itemCount / 2 + (currentIndex % realItemCount)
            let newIndexPath = IndexPath(item: newIndex, section: 0)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
}


