import UIKit
import SnapKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    private var isFavorite = false
    private let viewModel = MovieDetailViewModel()
    var movie: Movie?
    
    private let reservateButtonTapTrigger = Observable<Void>(())
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = true
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    private let contentView = UIView()
    
    private let moviePoster: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: "xmark") // Test
        return img
    }()
    
    private let plotLabel: UILabel = {
        let plot = UILabel()
        plot.font = .systemFont(ofSize: 16, weight: .medium)
        plot.numberOfLines = 0
        plot.textAlignment = .center
        return plot
    }()
    
    private lazy var reservateButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = UIColor(red: 32/255, green: 112/255, blue: 248/255, alpha: 1)
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.title = "지금 당장 예매"
        config.image = UIImage(systemName: "flame.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        config.imagePadding = 12
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(reservateButtonClicked), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        if let movie = movie {
            viewModel.setMovieData(movie: movie)
        }
    }
    
    private func bindViewModel() {
        let input = MovieDetailViewModel.Input(
            reservateButtonClick: reservateButtonTapTrigger
        )
        let output = viewModel.transform(input: input)
        
        output.movieTitle.bind { [weak self] title in
            self?.title = title
        }
        output.plot.bind { [weak self] plot in
            self?.plotLabel.text = plot
        }
        output.moviePoster.bind { [weak self] urlString in
            guard let urlString = urlString, let url = URL(string: urlString) else {
                self?.moviePoster.image = UIImage(systemName: "xmark")
                return
            }
            self?.moviePoster.kf.setImage(with: url)
        }
    }
    
    @objc
    private func reservateButtonClicked() {
        reservateButtonTapTrigger.value = ()
        
        let reservationVC = ReservationViewController()
        navigationController?.pushViewController(reservationVC, animated: true)
        
        reservationVC.moviePoster = moviePoster.image
        reservationVC.movieTitle = movie?.title
        reservationVC.movieOverview = movie?.overview

    }
    
    
}

extension MovieDetailViewController {
    private func setupViews() {
        view.backgroundColor = .white
        [scrollView, reservateButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [moviePoster, plotLabel].forEach { contentView.addSubview($0) }
        
        setupFavoriteButton()
    }
    private func setupConstraints() {
        reservateButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(60)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(reservateButton.snp.top)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        moviePoster.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(400)
        }
        plotLabel.snp.makeConstraints { make in
            make.top.equalTo(moviePoster.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
    
}

// MARK: - 즐겨찾기 버튼
extension MovieDetailViewController {
    private func setupFavoriteButton() {
        let starButton = UIButton(type: .system)
        updateFavoriteButton(button: starButton)
        
        starButton.snp.makeConstraints { make in
            make.size.equalTo(32)
        }
        
        let barButton = UIBarButtonItem(customView: starButton)
        navigationItem.rightBarButtonItem = barButton
    }
    private func updateFavoriteButton(button: UIButton) {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: isFavorite ? "star.fill" : "star")
        config.baseForegroundColor = .black
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = config
    }
}
