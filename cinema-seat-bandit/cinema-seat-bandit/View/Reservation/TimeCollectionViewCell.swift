import UIKit
import SnapKit

class TimeCollectionViewCell: UICollectionViewCell {
    static let identifier = "TimeCell"
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let theaterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        //stack.alignment = .leading
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .systemBackground
        
        [timeLabel, theaterLabel, remainingLabel].forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
    }
    
    func configure(time: String, theater: String, remaining: String, isSelected: Bool = false) {
        timeLabel.text = time
        theaterLabel.text = theater
        remainingLabel.text = "잔여: \(remaining)"
        
        if isSelected {
            contentView.backgroundColor = .systemBlue
            timeLabel.textColor = .white
            theaterLabel.textColor = .white.withAlphaComponent(0.9)
            remainingLabel.textColor = .white.withAlphaComponent(0.9)
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.backgroundColor = .systemBackground
            timeLabel.textColor = .black
            theaterLabel.textColor = .darkGray
            remainingLabel.textColor = .darkGray
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .systemBackground
        timeLabel.textColor = .black
        theaterLabel.textColor = .darkGray
        remainingLabel.textColor = .darkGray
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
