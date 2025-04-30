import UIKit
import SnapKit

class FirstReserveView: UIView {
    
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
        img.tintColor = UIColor.systemBlue
        return img
    }()
    
    private let secondProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "2.circle.fill")
        img.tintColor = UIColor.lightGray
        return img
    }()
    
    private let thirdProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "3.circle.fill")
        img.tintColor = UIColor.lightGray
        return img
    }()
    
    private let finalProcessImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "4.circle.fill")
        img.tintColor = UIColor.lightGray
        return img
    }()
    
    private let moviePosterImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(systemName: "xmark") // Test
        return img
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.title = "취소"
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        button.clipsToBounds = true
        return button
    }()

    private lazy var nextButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBlue
        configuration.baseForegroundColor = .white
        configuration.title = "다음"
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 8
        button.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        button.clipsToBounds = true
        return button
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
}

extension FirstReserveView {
    private func setupViews() {
        [stackView, moviePosterImage, buttonStackView].forEach { addSubview($0) }
        [firstProcessImage, secondProcessImage, thirdProcessImage, finalProcessImage].forEach {
            stackView.addArrangedSubview($0)
        }
        [cancelButton, nextButton].forEach { buttonStackView.addArrangedSubview($0) }
    }
    
    private func setupConstraints() {
        [firstProcessImage, secondProcessImage, thirdProcessImage, finalProcessImage].forEach {
            $0.snp.makeConstraints { make in
                make.size.equalTo(32)
            }
        }
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(120)
            make.directionalHorizontalEdges.equalToSuperview().inset(36)
            make.height.equalTo(32)
        }
        moviePosterImage.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(300)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(moviePosterImage.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(36)
            make.height.equalTo(54)
            make.bottom.lessThanOrEqualToSuperview().inset(24) // 안전한 하단 여백 추가
        }
    }
}
