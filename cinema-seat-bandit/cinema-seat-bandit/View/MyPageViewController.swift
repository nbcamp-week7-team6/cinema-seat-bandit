//
//  MyPageViewController.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/27/25.
//

import UIKit
import SnapKit

let dummyReservations: [Reservation] = [
    Reservation(reservationDate: "5.12 방문예정", theaterName: "CGV 용산아이파크몰", movieTitle: "범죄도시4"),
    Reservation(reservationDate: "5.14 방문예정", theaterName: "롯데시네마 월드타워", movieTitle: "혹성탈출: 새로운 시대"),
    Reservation(reservationDate: "5.15 방문예정", theaterName: "메가박스 코엑스", movieTitle: "가필드 더 무비"),
    Reservation(reservationDate: "5.17 방문예정", theaterName: "CGV 왕십리", movieTitle: "쿵푸팬더4"),
    Reservation(reservationDate: "5.18 방문예정", theaterName: "메가박스 강남", movieTitle: "스파이 패밀리 코드: 화이트"),
    Reservation(reservationDate: "5.20 방문예정", theaterName: "롯데시네마 건대입구", movieTitle: "듄: 파트2"),
    Reservation(reservationDate: "5.21 방문예정", theaterName: "CGV 홍대", movieTitle: "더 퍼스트 슬램덩크"),
    Reservation(reservationDate: "5.22 방문예정", theaterName: "메가박스 신촌", movieTitle: "엑스맨: 다크 피닉스"),
    Reservation(reservationDate: "5.23 방문예정", theaterName: "롯데시네마 김포공항", movieTitle: "007 노 타임 투 다이"),
    Reservation(reservationDate: "5.25 방문예정", theaterName: "CGV 압구정", movieTitle: "탑건: 매버릭")
]

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
        return dummyReservations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mypageView.tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.identifier) as? MyPageTableViewCell else {
            return UITableViewCell()
        }
        
        let reservation = dummyReservations[indexPath.row]
        
        cell.configure(with: reservation)
        
        return cell
    }
}
