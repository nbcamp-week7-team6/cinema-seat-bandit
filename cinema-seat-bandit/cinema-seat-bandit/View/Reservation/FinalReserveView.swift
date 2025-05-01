import UIKit
import SnapKit

class FinalReserveView: UIView {
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .equalSpacing
        return stack
    }()
    private let firstProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "1.circle.fill")
        img.tintColor = UIColor.lightGray
        return img
    }()
    private let secondProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "2.circle.fill")
        img.tintColor = UIColor.lightGray
        return img
    }()
    private let finalProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "3.circle.fill")
        img.tintColor = UIColor.systemBlue
        return img
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "예매 확인"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    // MARK: - 표
    private let infoTableView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    private let tableStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let movieTitleRow = TableRowView(title: "영화 제목")
    private let movieDateRow = TableRowView(title: "상영 날짜")
    private let movieTimeRow = TableRowView(title: "상영 시간")
    
    // 외부에서 값 변경
    var movieTitleLabel: UILabel { movieTitleRow.valueLabel }
    var movieDateLabel: UILabel { movieDateRow.valueLabel }
    var movieTimeLabel: UILabel { movieTimeRow.valueLabel }
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매 확정", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    var onConfirmTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupLayout() {
        backgroundColor = .white
        
        [stackView, titleLabel, infoTableView, confirmButton].forEach { addSubview($0) }
        [firstProcessImage, secondProcessImage, finalProcessImage].forEach {
            stackView.addArrangedSubview($0)
            $0.snp.makeConstraints { $0.size.equalTo(32) }
        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(156)
        }
        
        infoTableView.addSubview(tableStackView)
        [movieTitleRow, movieDateRow, movieTimeRow].forEach { tableStackView.addArrangedSubview($0) }
        tableStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(infoTableView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(54)
            make.bottom.lessThanOrEqualToSuperview().inset(24)
        }
    }
    
    func configure(movieTitle: String, date: String, time: String) {
        movieTitleLabel.text = movieTitle
        movieDateLabel.text = date
        movieTimeLabel.text = time
    }
    
    @objc private func confirmTapped() {
        onConfirmTapped?()
    }
}

private class TableRowView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemGray4
        return v
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        
        [titleLabel, valueLabel, separator].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
