import Foundation

final class ReservateViewModel {
    // MARK: - Section 타입
    enum Section: Int, CaseIterable {
        case date, time
    }
    
    // MARK: - Observable 데이터
    let dates: Observable<[String]> = Observable([
        "5월 25일\n(토)",
        "5월 26일\n(일)",
        "5월 27일\n(월)",
        "5월 28일\n(화)"
    ])
    let showtimes: Observable<[MockShowtime]>
    
    // MARK: - 선택 상태 관리
    let selectedDateIndex: Observable<Int> = Observable(0)
    let selectedShowtimeId: Observable<Int?> = Observable(nil)
    
    // MARK: - 초기화
    init(mockShowtimes: [MockShowtime]) {
        self.showtimes = Observable(mockShowtimes)
    }
    
    // MARK: - 공개 메소드
    func selectDate(at index: Int) {
        selectedDateIndex.value = index
    }
    
    func selectShowtime(id: Int) {
        selectedShowtimeId.value = id
    }
    
    // MARK: - CollectionView 보조 메소드
    func numberOfSections() -> Int {
        return Section.allCases.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .date:
            return dates.value.count
        case .time:
            return showtimes.value.count
        }
    }
    
    func isDateSelected(at index: Int) -> Bool {
        return selectedDateIndex.value == index
    }
    
    func isShowtimeSelected(at index: Int) -> Bool {
        guard index < showtimes.value.count else { return false }
        let showtime = showtimes.value[index]
        return selectedShowtimeId.value == showtime.id
    }
    
    // 시간 정보 포맷팅 (화면에 보이는 것처럼)
    func getShowtimeInfo(at index: Int) -> (time: String, theater: String, remaining: String)? {
        guard index < showtimes.value.count else { return nil }
        let showtime = showtimes.value[index]
        
        // 잔여 좌석 계산
        let reservedCount = showtime.seats.filter { $0.isReserved }.count
        let totalCount = showtime.seats.count
        let remaining = "\(totalCount - reservedCount)/\(totalCount)"
        
        // 상영관 정보 (이미지에 맞게 샘플 데이터 생성)
        let theater: String
        switch index % 3 {
        case 0: theater = "1관 (일반)"
        case 1: theater = "2관 (IMAX)"
        case 2: theater = "3관 (4DX)"
        default: theater = "1관 (일반)"
        }
        
        return (showtime.time, theater, remaining)
    }
    
    // 선택된 날짜 계산
    private var selectedDate: String? {
        guard selectedDateIndex.value < dates.value.count else { return nil }
        return dates.value[selectedDateIndex.value]
    }
    
    // 선택된 상영시간 계산
    private var selectedShowtime: (time: String, theater: String, remaining: String)? {
        guard let id = selectedShowtimeId.value,
              let showtime = showtimes.value.first(where: { $0.id == id }) else { return nil }
        return getShowtimeInfo(at: showtimes.value.firstIndex(where: { $0.id == id }) ?? 0)
    }
}
