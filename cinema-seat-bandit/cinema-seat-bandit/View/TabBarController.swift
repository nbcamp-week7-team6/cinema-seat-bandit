//
//  Untitled.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }

    private func setupTabBar() {
        let movieListVC = MovieListViewController()
        let myPageVC = MyPageViewController()
        let searchVC = MovieSearchViewController()

        let movieListNav = UINavigationController(rootViewController: movieListVC)
        let myPageNav = UINavigationController(rootViewController: myPageVC)
        let searchNav = UINavigationController(rootViewController: searchVC)

        movieListNav.tabBarItem = UITabBarItem(
            title: "영화목록",
            image: "📺".emojiToImage()?.withRenderingMode(.alwaysOriginal),
            selectedImage: "📺".emojiToImage()?.withRenderingMode(.alwaysOriginal)
        )

        searchNav.tabBarItem = UITabBarItem(
            title: "영화검색",
            image: "🔍".emojiToImage()?.withRenderingMode(.alwaysOriginal),
            selectedImage: "🔍".emojiToImage()?.withRenderingMode(.alwaysOriginal)
        )

        myPageNav.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: "🏠".emojiToImage()?.withRenderingMode(.alwaysOriginal),
            selectedImage: "🏠".emojiToImage()?.withRenderingMode(.alwaysOriginal)
        )

        let iconItems = [movieListNav, searchNav, myPageNav]

        iconItems.forEach{
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)
            $0.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
        }
        viewControllers = iconItems

        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
    }
}

extension String {
    func emojiToImage() -> UIImage? {
        let size: CGFloat = 24
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { _ in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size)
            ]
            let textSize = self.size(withAttributes: attributes)
            let rect = CGRect(
                x: (size - textSize.width) / 2,
                y: (size - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            self.draw(in: rect, withAttributes: attributes)
        }
    }
}
