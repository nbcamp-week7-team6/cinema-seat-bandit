import Foundation

final class MovieDetailViewModel: ViewModelProtocol {
    
    private(set) var titleSubject = Observable<String>("")
    private(set) var posterSubject = Observable<String?>(nil)
    private(set) var plotSubject = Observable<String>("")
    
    struct Input {
        let reservateButtonClick: Observable<Void>
    }
    struct Output {
        let movieTitle: Observable<String>
        let moviePoster: Observable<String?>
        let plot: Observable<String>
    }
    
    func transform(input: Input) -> Output {
        input.reservateButtonClick.bind { [weak self] _ in
            print("예매 버튼 클릭됨")
        }
        return Output(
            movieTitle: titleSubject,
            moviePoster: posterSubject,
            plot: plotSubject
        )
    }
    
    func setMovieData(movie: Movie) {
        titleSubject.value = movie.title
        posterSubject.value = movie.poster_path.map { "https://image.tmdb.org/t/p/w500\($0)" }
        plotSubject.value = movie.overview.isEmpty ? "줄거리 정보가 없습니다." : movie.overview
    }
}
