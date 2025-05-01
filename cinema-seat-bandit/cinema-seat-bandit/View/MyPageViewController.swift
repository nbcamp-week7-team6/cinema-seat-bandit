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
        
        return cell
    }
}
