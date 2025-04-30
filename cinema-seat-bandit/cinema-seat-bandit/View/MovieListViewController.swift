import UIKit
import SnapKit

final class MovieListViewController: UIViewController {

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

    private let popularSection = MovieSectionView(title: "Popular")
    private let upcomingSection = MovieSectionView(title: "Upcoming")

    override func viewDidLoad() {
        print("MovieListViewController 실행 확인")
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        loadTrendingData()
        loadUpcommingData()
        setupClickEvents()

    }

    private func loadTrendingData() {
        NetworkManager.shared.request(api: .trending()) {
            (result: Result<TrendingResponse, Error>) in
            switch result {
            case .success(let response):
                self.popularSection.setMovies(response.results)
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }

    private func loadUpcommingData() {
        NetworkManager.shared.request(api: .upcoming()) {
            (result: Result<UpcommingResponse, Error>) in
            switch result {
            case .success(let response):
                self.upcomingSection.setMovies(response.results)
            case .failure(let error):
                print("에러 발생: \(error)")
            }
        }
    }

    private func setupClickEvents() {
        popularSection.onMovieTapped = { [weak self] movie in
            let detailVC = MovieDetailViewController()
            detailVC.movie = movie
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }

        upcomingSection.onMovieTapped = { [weak self] movie in
            let detailVC = MovieDetailViewController()
            detailVC.movie = movie
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
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
}
