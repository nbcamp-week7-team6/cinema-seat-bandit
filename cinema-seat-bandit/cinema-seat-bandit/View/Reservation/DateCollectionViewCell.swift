import UIKit
import SnapKit

class DateCollectionViewCell: UICollectionViewCell {
    static let identifier = "DateCell"
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.backgroundColor = .systemBackground
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
    
    func configure(with text: String, isSelected: Bool = false) {
        dateLabel.text = text
        
        if isSelected {
            contentView.backgroundColor = .systemBlue
            dateLabel.textColor = .white
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.backgroundColor = .systemBackground
            dateLabel.textColor = .black
            contentView.layer.borderColor = UIColor.systemGray5.cgColor
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .systemBackground
        dateLabel.textColor = .black
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
