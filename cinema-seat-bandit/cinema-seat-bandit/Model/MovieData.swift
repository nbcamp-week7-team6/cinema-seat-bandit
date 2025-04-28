// MARK: - 트렌딩 영화 목록 응답 (GET: /3/trending/movie/day)
struct TrendingResponse: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

// MARK: - 영화 기본 정보 (트렌딩/검색 공통)
struct Movie: Decodable {
    let id: Int
    let backdrop_path: String?    // 배경 이미지 경로 (Optional)
    let title: String             // 현지화 제목
    let original_title: String    // 원제
    let overview: String          // 줄거리 (빈 문자열 가능)
    let poster_path: String?      // 포스터 경로 (Optional)
    let media_type: String        // 미디어 타입 (movie/tv)
    let adult: Bool               // 성인 콘텐츠 여부
    let original_language: String // 원본 언어 (ISO 639-1)
    let genre_ids: [Int]          // 장르 ID 배열
    let popularity: Double        // 인기도 점수
    let release_date: String?     // 개봉일 (Optional)
    let video: Bool               // 예고편 존재 여부
    let vote_average: Double      // 평균 평점
    let vote_count: Int           // 평점 개수
}

// MARK: - 영화 이미지 응답 (GET: /3/movie/{id}/images)
struct ImageResponse: Decodable {
    let backdrops: [ImageInfo]  // 배경 이미지 목록
    let posters: [ImageInfo]    // 포스터 이미지 목록
}

struct ImageInfo: Decodable {
    let file_path: String       // 이미지 경로
}

// MARK: - 영화 출연진 응답 (GET: /3/movie/{id}/credits)
struct CreditResponse: Decodable {
    let cast: [CastMember]      // 출연진 목록
}

struct CastMember: Decodable {
    let name: String            // 배우 이름
    let character: String       // 배역 이름
    let profile_path: String?   // 프로필 이미지 경로 (Optional)
}

// MARK: - 검색 결과 응답 (GET: /3/search/movie)
struct SearchResponse: Decodable {
    let page: Int
    let results: [Movie]        // 검색된 영화 목록
    let total_pages: Int
    let total_results: Int
}
