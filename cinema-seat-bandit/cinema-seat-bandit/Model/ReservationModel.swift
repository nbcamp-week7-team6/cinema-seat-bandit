//
//  ReservationModel.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 5/1/25.
//

import Foundation
import FirebaseFirestore

struct ReservationModel {
    let movieTitle: String
    let overview: String
    let posterImageURL: String
    let createdAt: Date
    let screeningDate: Date
    
    var dictionary: [String: Any] {
        return [
            "movieTitle": movieTitle,
            "overview": overview,
            "posterImageURL": posterImageURL,
            "createdAt": Timestamp(date: createdAt),
            "screeningDate": Timestamp(date: screeningDate)
        ]
    }
    
    var statusText: String {
        let today = Calendar.current.startOfDay(for: Date())
        let screeningDay = Calendar.current.startOfDay(for: screeningDate)
        return screeningDay < today ? "상영완료" : "방문예정"
    }
    
    init(movieTitle: String, overview: String, posterImageURL: String, createdAt: Date = Date(), screeningDateString: String) {
        self.movieTitle = movieTitle
        self.overview = overview
        self.posterImageURL = posterImageURL
        self.createdAt = createdAt
        self.screeningDate = ReservationModel.parseDate(from: screeningDateString)
    }
    
    init?(dictionary: [String: Any]) {
        guard let movieTitle = dictionary["movieTitle"] as? String,
              let overview = dictionary["overview"] as? String,
              let posterImageURL = dictionary["posterImageURL"] as? String,
              let createdAt = dictionary["createdAt"] as? Timestamp,
              let screeningDate = dictionary["screeningDate"] as? Timestamp else {
            return nil
        }
        
        self.movieTitle = movieTitle
        self.overview = overview
        self.posterImageURL = posterImageURL
        self.createdAt = createdAt.dateValue()
        self.screeningDate = screeningDate.dateValue()
    }
    
    private static func parseDate(from rawString: String) -> Date {
        let cleanedString = rawString.components(separatedBy: "\n").first ?? rawString
        let year = Calendar.current.component(.year, from: Date())
        let fullDateString = "\(year)년 \(cleanedString)"
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        
        if let date = formatter.date(from: fullDateString) {
            return date
        }
        
        return Date()
    }

}
