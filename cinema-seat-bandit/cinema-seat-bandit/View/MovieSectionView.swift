//
//  MovieSectionView.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

final class MovieSectionView: UIView {

    var movies: [Movie] = []
    var onMovieTapped: ((Movie) -> Void)?


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
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setupViews() {
        [titleLabel, collectionView]
            .forEach{ addSubview($0)}
    }

    func setMovies(_ movies: [Movie]) {
        self.movies = Array(repeating: movies, count: 3).flatMap { $0 }
        collectionView.reloadData()

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded() //화면이 전활 될 때도 호출이됨
            self.scrollToMiddle()
        }
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

// MARK: - UICollectionViewDataSource

extension MovieSectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: movies[indexPath.item], showVoteAverage: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
        onMovieTapped?(selectedMovie)
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
        let realItemCount = movies.count

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


