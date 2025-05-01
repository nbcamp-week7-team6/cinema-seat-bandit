//
//  TestReservationViewController.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 5/1/25.
//

import UIKit

final class TestReservationViewController: UIViewController {
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("예약 3건 저장", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("예약 불러오기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let dummyMovies: [(title: String, overview: String, posterURL: String, screeningDate: String)] = [
        ("씨너스: 죄인들",
         "과거의 상처를 뒤로하고 고향으로 돌아온 쌍둥이 형제. 새로운 시작을 꿈꾸지만, 마을에는 설명할 수 없는 기이한 사건들이 연이어 발생한다. 점점 드러나는 가족의 비밀과 숨겨진 어둠. 그들은 과거의 악몽과 마주하게 되는데...",
         "/jYfMTSiFFK7ffbY2lay4zyvTkEk.jpg",
        "4월 29일\n(토)"),
        ("잠겨진",
         "\"탈출구 없는 SUV, 그 안에 갇힌 두 남자의 심리전\"  딸과의 약속을 지키기 위해 절박한 상황에 놓인 소매치기 에디는 우연히 발견한 고급 SUV에 손을 댄다. 그러나 차량은 단단히 잠겨 있고, 그는 순식간에 그 안에 갇히고 만다. 이 모든 것은 차량 주인 윌리엄의 치밀한 계획이었다. 암 투병 중인 부유한 의사 윌리엄은 과거의 상처를 이유로, 범죄자들에게 자신만의 방식으로 정의를 실현하려 한다. 에디는 점점 더 가혹해지는 심리적·육체적 압박 속에서 생존을 위한 싸움을 시작하게 되는데...",
         "/hhkiqXpfpufwxVrdSftzeKIANl3.jpg",
         "5월 7일\n(토)"),
        ("데스 오브 유니콘",
         "​\"그날 밤, 그들은 상상조차 못한 존재와 마주쳤다\"\r 과부인 엘리엇 킨터와 그의 딸 리들리는 캐나다 로키산맥으로 떠나는 길에 우연히 신비로운 새끼 유니콘과 충돌하게 된다. 이 사건으로 인해 그들은 엘리엇의 억만장자 상사인 오델 레오폴드의 별장에 도착하게 되고, 레오폴드 가족은 유니콘의 치유력을 탐내기 시작한다. 하지만 그들이 간과한 사실은, 유니콘의 부모가 그들의 새끼를 찾기 위해 다가오고 있다는 것인데...",
         "/lXR32JepFwD1UHkplWqtBP1K79z.jpg",
         "5월 12일\n(토)")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(saveButton)
        view.addSubview(fetchButton)

        saveButton.addTarget(self, action: #selector(saveTestReservations), for: .touchUpInside)
        fetchButton.addTarget(self, action: #selector(fetchTestReservations), for: .touchUpInside)

        setupConstraints()
    }
    
    private func setupConstraints() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        fetchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 44),

            fetchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fetchButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            fetchButton.widthAnchor.constraint(equalToConstant: 200),
            fetchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func saveTestReservations() {
        for movie in dummyMovies {
            ReservationService.shared.saveReservation(
                movieTitle: movie.title,
                overview: movie.overview,
                posterImageURL: movie.posterURL,
                screeningDateString: movie.screeningDate
            ) { result in
                switch result {
                case .success:
                    print("✅ 저장 성공: \(movie.title)")
                case .failure(let error):
                    print("❌ 저장 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    @objc private func fetchTestReservations() {
        ReservationService.shared.fetchReservations { result in
            switch result {
            case .success(let reservations):
                print("✅ 불러오기 성공: \(reservations.map { $0.movieTitle })")
            case .failure(let error):
                print("❌ 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
}
