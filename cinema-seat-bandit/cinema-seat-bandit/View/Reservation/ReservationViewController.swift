import UIKit
import SnapKit
import Kingfisher

class ReservationViewController: UIViewController {
    private let firstProcess = FirstReserveView()
    private let secondProcess = SecondReserveView()
    private let finalProcess = FinalReserveView()
    
    var moviePoster: UIImage?
    var movieTitle: String?
    var movieOverview: String?
    var moviePosterURL: String?
    var selectedDate: String?
    var selectedTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupInitialView()
        setupCallbacks()
        updatePoster()
    }
    
    private func setupInitialView() {
        view.addSubview(firstProcess)
        firstProcess.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupCallbacks() {
        // 1. 첫 번째 뷰 콜백
        firstProcess.onNextButtonTapped = { [weak self] in
            self?.transitionToSecondProcess()
        }
        firstProcess.onCancelButtonTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // 2. 두 번째 뷰 콜백
        secondProcess.onReserveCompleted = { [weak self] date, time in
            self?.transitionToFinalProcess(date: date, time: time)
        }
        secondProcess.onPreviousButtonTapped = { [weak self] in
            self?.transitionToFirstProcess()
        }
        
        // 예매 확정(예매하기) 버튼 액션
        finalProcess.onConfirmTapped = { [weak self] in
            guard let self = self else { return }
            ReservationService.shared.saveReservation(
                movieTitle: self.movieTitle ?? "",
                overview: self.movieOverview ?? "",
                posterImageURL: self.moviePosterURL ?? "",
                screeningDateString: self.selectedDate ?? ""
            ) { result in
                switch result {
                case .success():
                    let alert = UIAlertController(
                        title: "예매 완료",
                        message: "영화 예매가 완료되었습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                        let myPageVC = MyPageViewController()
                        self.navigationController?.pushViewController(myPageVC, animated: true)
                    })
                    self.present(alert, animated: true)
                case .failure(let error):
                    let alert = UIAlertController(
                        title: "오류",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func transitionToFirstProcess() {
        secondProcess.removeFromSuperview()
        view.addSubview(firstProcess)
        firstProcess.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func transitionToSecondProcess() {
        firstProcess.removeFromSuperview()
        view.addSubview(secondProcess)
        secondProcess.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func transitionToFinalProcess(date: String, time: String) {
        secondProcess.removeFromSuperview()
        view.addSubview(finalProcess)
        finalProcess.snp.makeConstraints { $0.edges.equalToSuperview() }
        finalProcess.configure(
            movieTitle: movieTitle ?? "",
            date: date,
            time: time
        )
    }
    
    private func updatePoster() {
        firstProcess.moviePosterImage.image = moviePoster
    }
}
