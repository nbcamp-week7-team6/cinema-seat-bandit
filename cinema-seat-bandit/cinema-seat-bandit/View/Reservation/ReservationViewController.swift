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
        
        // 3. 최종 뷰 콜백
        finalProcess.onConfirmTapped = { [weak self] in
            let alert = UIAlertController(
                title: "예매 완료",
                message: "영화 예매가 완료되었습니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                let myPageVC = MyPageViewController()
                self?.navigationController?.pushViewController(myPageVC, animated: true)
            })
            self?.present(alert, animated: true)
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
