import UIKit
import SnapKit

final class MovieListViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true

        scrollView.backgroundColor = .green
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .yellow
        return stackView
    }()

    private let popularSection = MovieSectionView(title: "Popular")
    private let upcomingSection = MovieSectionView(title: "Upcoming")

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        popularSection.scrollToMiddle()
        upcomingSection.scrollToMiddle()
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
