//
//  MovieSearchViewController.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/29/25.
//
import UIKit
import SnapKit

class MovieSearchViewController: UIViewController {

    private var movies: [Movie] = []
    private var currentPage = 1
    private var totalPages = 20
    private var isLoading = false
    private var currentQuery: String = ""

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "제목으로 검색해주세요."
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        return searchBar
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        let width = (UIScreen.main.bounds.width - (spacing * 4)) / 3
        layout.itemSize = CGSize(width: width, height: width * 1.5 + 40)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setupCollectionView()
        searchBar.delegate = self
        searchMovieUsingAPI(query: "굿")

    }

    private func setupLayout() {

        [searchBar, collectionView]
            .forEach{ view.addSubview($0)}

        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func searchMovieUsingAPI(query: String, page: Int = 1) {
        guard !isLoading else { return }
        isLoading = true
        currentQuery = query

        NetworkManager.shared.request(api: .search(query: query, page: page)) {
            (result: Result<SearchResponse, Error>) in
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let response):
                    self.totalPages = response.total_pages

                    if page == 1 {
                        self.movies = response.results
                    } else {
                        self.movies += response.results
                    }

                    self.collectionView.reloadData()
                    self.currentPage = page
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                }
            }
        }
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {

            if !isLoading && currentPage < totalPages {
                let nextPage = currentPage + 1
                searchMovieUsingAPI(query: currentQuery, page: nextPage)
            }
        }
    }


    private func setupCollectionView() {

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
    }
}

extension MovieSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.item], showVoteAverage: false)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let detailVC = MovieDetailViewController()
        detailVC.movie = movie
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


extension MovieSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
            currentPage = 1
            totalPages = 1
            movies = []
            collectionView.reloadData()
            searchMovieUsingAPI(query: query, page: 1)
    }
}

