//
//  MyPageViewController.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

final class MyPageViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        return sv
    }()
    
    private let mypageView = MyPageView()
    
    private let viewModel = MyPageViewModel()
    
    private let didLoadView = Observable<Void>(())
    private let didTapLogout = Observable<Void?>(nil)
    
    private var reservations: [ReservationModel] = []
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "예매 내역이 없습니다."
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
        setupConstraints()
        setupTableView()
        bindViewModel()
        setupActions()
        
        didLoadView.value = ()
    }
    
    private func setupViews() {
        titleStackView.addArrangedSubview(titleLabel)
        
        [
            titleStackView,
            mypageView
        ].forEach { view.addSubview($0) }
    }
    
    private func setupConstraints() {
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        mypageView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        mypageView.tableView.separatorStyle = .none
        mypageView.tableView.showsVerticalScrollIndicator = false
        mypageView.tableView.dataSource = self
        mypageView.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupActions() {
        mypageView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    @objc private func logoutButtonTapped() {
        didTapLogout.value = ()
    }
    
    private func bindViewModel() {
        let input = MyPageViewModel.Input(
            didLoadView: didLoadView,
            didTapLogout: didTapLogout
        )
        
        let output = viewModel.transform(input: input)
        
        output.userEmail.bind { [weak self] email in
            self?.mypageView.userNameLabel.text = "안녕하세요, \(email)"
        }
        
        output.logoutSuccess.bind { [weak self] isLoggedOut in
            if isLoggedOut {
                self?.moveToLoginScreen()
            }
        }
        
        output.reservations.bind { [weak self] reservationList in
            if reservationList.isEmpty {
                self?.mypageView.tableView.backgroundView = self?.emptyStateLabel
            } else {
                self?.mypageView.tableView.backgroundView = nil
            }
            self?.reservations = reservationList
            self?.mypageView.tableView.reloadData()
        }
    }
    
    private func moveToLoginScreen() {
        let loginVC = AuthViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? UIWindowSceneDelegate,
           let window = (sceneDelegate as? NSObject)?.value(forKey: "window") as? UIWindow {
            
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mypageView.tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        
        let reservation = reservations[indexPath.row]
        
        cell.configure(with: reservation)
        
        cell.onDetailButtonTapped = { [weak self] in
            let detailVC = MovieDetailViewController()
            detailVC.movie = reservation.toMovie()
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        return cell
    }
}

extension ReservationModel {
    func toMovie() -> Movie {
        return Movie(
            id: -1,
            backdrop_path: nil,
            title: movieTitle,
            original_title: movieTitle,
            overview: overview,
            poster_path: posterImageURL,
            media_type: "movie",
            adult: false,
            original_language: "ko",
            genre_ids: [],
            popularity: 0.0,
            release_date: nil,
            video: false,
            vote_average: 0.0,
            vote_count: 0
        )
    }
}
