import UIKit
import SnapKit

final class MovieListViewController: UIViewController {

    let movieListVM = MovieListViewModel()

    private var popularMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []

    private let popularSection = MovieSectionView(title: "Popular")
    private let upcomingSection = MovieSectionView(title: "Upcoming")

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        [popularSection, upcomingSection]
            .forEach {stackView.addArrangedSubview($0)}
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        setupDelegates()
        bindOnClickedEvents()
        movieListVM.updateTrendingMovie()
        movieListVM.updateUpcomingMovies()

    }

    private func setupDelegates() {
        popularSection.collectionView.delegate = self
        popularSection.collectionView.dataSource = self
        upcomingSection.collectionView.delegate = self
        upcomingSection.collectionView.dataSource = self
    }

    private func bindOnClickedEvents() {
        movieListVM.trendingMovieUpdated = { [weak self] movies in
            self?.popularMovies = movies
            self?.popularSection.collectionView.reloadData()
            self?.scrollToMiddle(collectionView: self?.popularSection.collectionView)
        }

        movieListVM.upcomingMovieUpdated = { [weak self] movies in
            self?.upcomingMovies = movies
            self?.upcomingSection.collectionView.reloadData()
            self?.scrollToMiddle(collectionView: self?.upcomingSection.collectionView)
        }
    }



    func scrollToMiddle(collectionView: UICollectionView?) {
        guard let collectionView = collectionView else { return }
        let middleIndexPath = IndexPath(item: popularMovies.count / 2, section: 0)
        collectionView.scrollToItem(at: middleIndexPath, at: .centeredHorizontally, animated: false)
    }
}


// MARK: - UICollectionViewDataSource, delegate

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == popularSection.collectionView {
            return popularMovies.count
        } else {
            return upcomingMovies.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }

        let movie = (collectionView == popularSection.collectionView)
        ? popularMovies[indexPath.item]
        : upcomingMovies[indexPath.item]

        cell.configure(with: movie, showVoteAverage: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let movieItems = (collectionView == popularSection.collectionView)
        ? popularMovies[indexPath.item]
        : upcomingMovies[indexPath.item]

        let detailVC = MovieDetailViewController()
        detailVC.movie = movieItems
        navigationController?.pushViewController(detailVC, animated: true)
    }


}

extension MovieListViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        guard let collectionView = scrollView as? UICollectionView else { return }

        let visibleItems = collectionView.indexPathsForVisibleItems
        guard let currentIndex = visibleItems.sorted().first?.item else { return }

        let count = (collectionView == popularSection.collectionView)
        ? popularMovies.count
        : upcomingMovies.count

        if currentIndex <= count {
            let newIndex = count / 2 + currentIndex
            collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: .centeredHorizontally, animated: false)
        } else if currentIndex >= count * 2 {
            let newIndex = count / 2 + (currentIndex % count)
            collectionView.scrollToItem(at: IndexPath(item: newIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

