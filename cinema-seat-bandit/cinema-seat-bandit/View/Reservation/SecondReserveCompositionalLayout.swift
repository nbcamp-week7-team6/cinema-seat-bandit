import UIKit

enum SecondReserveSection: Int, CaseIterable {
    case date, time
}

struct SecondReserveCompositionalLayout {
    static func create() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
            switch SecondReserveSection(rawValue: section) {
            case .date:
                let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(400), heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 24, trailing: 8)
                section.interGroupSpacing = 8
                return section
                
            case .time:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49), heightDimension: .estimated(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(64))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
                group.interItemSpacing = .flexible(8)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
                section.interGroupSpacing = 12
                return section
                
            default:
                return nil
            }
        }
    }
}
