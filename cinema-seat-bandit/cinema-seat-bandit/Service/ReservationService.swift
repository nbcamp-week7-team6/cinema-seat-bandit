//
//  ReservationService.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/30/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ReservationError: LocalizedError {
    case notLoggedIn
    case firestoreError(String)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return "로그인하지 않은 사용자입니다."
        case .firestoreError(let message):
            return "firestore 오류: \(message)"
        case .decodingFailed:
            return "예매 내역을 디코딩하는데 실패했습니다."
        }
    }
}

struct ReservationModel {
    let movieTitle: String
    let overview: String
    let posterImageURL: String
    let createdAt: Date
    
    var dictionary: [String: Any] {
        return [
            "movieTitle": movieTitle,
            "overview": overview,
            "posterImageURL": posterImageURL,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
    
    init(movieTitle: String, overview: String, posterImageURL: String, createdAt: Date = Date()) {
        self.movieTitle = movieTitle
        self.overview = overview
        self.posterImageURL = posterImageURL
        self.createdAt = createdAt
    }
    
    init?(dictionary: [String: Any]) {
        guard let movieTitle = dictionary["movieTitle"] as? String,
              let overview = dictionary["overview"] as? String,
              let posterImageURL = dictionary["posterImageURL"] as? String,
              let createdAt = dictionary["createdAt"] as? Timestamp else {
            return nil
        }
        
        self.movieTitle = movieTitle
        self.overview = overview
        self.posterImageURL = posterImageURL
        self.createdAt = createdAt.dateValue()
    }
}

final class ReservationService {
    static let shared = ReservationService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveReservation(movieTitle: String, overview: String, posterImageURL: String, completion: ((Result<Void, ReservationError>) -> Void)? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion?(.failure(.notLoggedIn))
            return
        }
        
        let data = ReservationModel(
            movieTitle: movieTitle,
            overview: overview,
            posterImageURL: posterImageURL
        )
        
        db.collection("users").document(uid)
            .collection("reservations")
            .addDocument(data: data.dictionary) { error in
                if let error = error {
                    completion?(.failure(.firestoreError(error.localizedDescription)))
                } else {
                    completion?(.success(()))
                }
            }
    }
    
    func fetchReservations(completion: @escaping (Result<[ReservationModel], ReservationError>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(.notLoggedIn))
            return
        }
        
        db.collection("users").document(uid)
            .collection("reservations")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.firestoreError(error.localizedDescription)))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.failure(.decodingFailed))
                    return
                }
                
                let reservations = documents.compactMap { ReservationModel(dictionary: $0.data()) }
                
                completion(.success(reservations))
            }
    }
}
