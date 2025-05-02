//
//  MovieListViewModel.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 5/1/25.
//

class MovieListViewModel {

    var trendingMovieUpdated: (([Movie]) -> Void)?
    var upcomingMovieUpdated: (([Movie]) -> Void)?

    func updateTrendingMovie() {
        NetworkManager.shared.request(api: .trending()) {
            (result: Result<TrendingResponse, Error>) in
            switch result {
            case .success(let response):
                let movies = Array(repeating: response.results, count: 3).flatMap { $0 }
                self.trendingMovieUpdated?(movies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func updateUpcomingMovies() {
        NetworkManager.shared.request(api: .upcoming()) {
            (result: Result<UpcomingResponse, Error>) in
            switch result {
            case .success(let response):
                let movies = Array(repeating: response.results, count: 3).flatMap { $0 }
                self.upcomingMovieUpdated?(movies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
