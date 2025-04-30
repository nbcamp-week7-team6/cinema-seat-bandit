import UIKit
import SnapKit

class SecondReserveView: UIView {
    
    private let viewModel = ReservateViewModel(mockShowtimes: mockShowtimes)
    
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
        img.tintColor = UIColor.systemBlue
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
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.text = "상영 일자 선택"
        title.font = .boldSystemFont(ofSize: 24)
        return title
    }()
    
    private let collectionView: UICollectionView = {
        let layout = SecondReserveCompositionalLayout.create()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var previousButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .black
        configuration.title = "이전"
        
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
        setupCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondReserveView {
    private func setupViews() {
        [stackView, titleLabel, collectionView, buttonStackView].forEach { addSubview($0) }
        [firstProcessImage, secondProcessImage, thirdProcessImage, finalProcessImage].forEach {
            stackView.addArrangedSubview($0)
        }
        [previousButton, nextButton].forEach { buttonStackView.addArrangedSubview($0) }
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
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(12)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(400)
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(36)
            make.height.equalTo(54)
            make.bottom.lessThanOrEqualToSuperview().inset(24)
        }
    }
}

extension SecondReserveView {
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(DateCollectionViewCell.self,
                                forCellWithReuseIdentifier: DateCollectionViewCell.identifier)
        collectionView.register(TimeCollectionViewCell.self,
                                forCellWithReuseIdentifier: TimeCollectionViewCell.identifier)
        
        viewModel.dates.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: ReservateViewModel.Section.date.rawValue))
        }
        
        viewModel.showtimes.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: ReservateViewModel.Section.time.rawValue))
        }
        
        viewModel.selectedDateIndex.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: ReservateViewModel.Section.date.rawValue))
        }
        
        viewModel.selectedShowtimeId.bind { [weak self] _ in
            self?.collectionView.reloadSections(IndexSet(integer: ReservateViewModel.Section.time.rawValue))
        }
    }
}

extension SecondReserveView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = ReservateViewModel.Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCollectionViewCell
            let dateText = viewModel.dates.value[indexPath.item]
            let isSelected = viewModel.isDateSelected(at: indexPath.item)
            cell.configure(with: dateText, isSelected: isSelected)
            return cell
            
        case .time:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeCell", for: indexPath) as! TimeCollectionViewCell
            if let info = viewModel.getShowtimeInfo(at: indexPath.item) {
                let isSelected = viewModel.isShowtimeSelected(at: indexPath.item)
                cell.configure(time: info.time, theater: info.theater, remaining: info.remaining, isSelected: isSelected)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = ReservateViewModel.Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .date:
            viewModel.selectDate(at: indexPath.item)
        case .time:
            let showtime = viewModel.showtimes.value[indexPath.item]
            viewModel.selectShowtime(id: showtime.id)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    
}
