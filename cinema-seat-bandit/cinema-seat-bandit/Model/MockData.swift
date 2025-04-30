// 좌석 정보 구조체
struct MockSeat {
    let seatNumber: String
    var isReserved: Bool
}

// 상영 시간 정보 구조체
struct MockShowtime {
    let id: Int
    let time: String
    let seats: [MockSeat]
}

let seatCount = 20

let mockShowtimes: [MockShowtime] = [
    MockShowtime(
        id: 1,
        time: "10:00",
        seats: (1...seatCount).map { MockSeat(seatNumber: "A\($0)", isReserved: Bool.random()) }
    ),
    MockShowtime(
        id: 2,
        time: "12:00",
        seats: (1...seatCount).map { MockSeat(seatNumber: "A\($0)", isReserved: Bool.random()) }
    ),
    MockShowtime(
        id: 3,
        time: "14:00",
        seats: (1...seatCount).map { MockSeat(seatNumber: "A\($0)", isReserved: Bool.random()) }
    ),
    MockShowtime(
        id: 4,
        time: "16:00",
        seats: (1...seatCount).map { MockSeat(seatNumber: "A\($0)", isReserved: Bool.random()) }
    ),
    MockShowtime(
        id: 5,
        time: "18:00",
        seats: (1...seatCount).map { MockSeat(seatNumber: "A\($0)", isReserved: Bool.random()) }
    )
]
