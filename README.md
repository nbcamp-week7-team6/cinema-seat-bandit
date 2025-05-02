# Cinema Seat Bandit - 영화관 좌석털이범

## 프로젝트 소개

** Cinema Seat Bandit**는 영화 예매 및 영화 정보 조회가 가능한 iOS 사이드 프로젝트입니다.  
사용자는 다양한 카테고리의 영화들을 확인하고, 예매 후 내역을 확인 할 수 있습니다.  
현재 TMDB API 하나만 사용 되었습니다.

- **영화 카테고리 조회**: 현재 Trending, Upcoming 카테고리
- **영화 상세 정보 확인**: 제목, 줄거리, 포스터, 영화 시간대(Mock Data) 등의 상세 정보 제공
- **실시간 예매 내역**: 주문 데이터는 FireBase DB에 실시간 반영

## 시연 영상
[https://github.com/user-attachments/assets/5d356eef-735b-472c-906e-fb4e2f20e9bd](https://www.youtube.com/shorts/qt4B56pbZx4)

## 기술스택
### 📌 개발 환경
- **Swift**  
  iOS 앱 개발을 위한 프로그래밍 언어
- **Xcode 16.0**  
  iOS 앱 개발을 위한 공식 IDE

### 🎨 UI 구성
- **UIKit**  
  전통적인 iOS UI 구성 프레임워크
- **SnapKit**  
  AutoLayout을 코드로 간결하게 작성할 수 있는 DSL 라이브러리
- **UICollectionView Compositional Layout**  
  복잡한 레이아웃을 손쉽게 구성할 수 있는 컬렉션 뷰 레이아웃 방식
- **KingFisher**  
  이미지를 URL로 쉽게 다운로드하고 캐싱하는 라이브러리
- **AlamoFire**  
   HTTP 네트워크 요청을 간단하게 처리하는 라이브러리


### 🔄 반응형 프로그래밍
- **Custom Observable Class**  
  클로저를 통한 데이터 바인딩

### ☁️ 백엔드 및 데이터 관리
- **Firebase**  
  실시간 데이터베이스 및 백엔드 서비스 제공 플랫폼

## 역할 분담

<div align="center">

| [윤주형](https://github.com/youseokhwan) | [김신영](https://github.com/SongKyuSeob) | [고욱현](https://github.com/imo2k) |
|:-----:|:-----:|:-----:|
| 팀장 👑 | 팀원 👨🏻‍💻 | 팀원 👨🏻‍💻 |
| 영화 목록<br/>영화 검색 | 파이어베이스<br/>로그인·회원가입<br/>마이페이지·예매내역 | 영화 상세 정보<br/>영화 예매<br/>네트워크 구성 |

</div>



## 파일 구조
```
.
├── cinema-seat-bandit
│   ├── Application
│   │   ├── AppDelegate.swift
│   │   ├── Assets.xcassets
│   │   ├── Base.lproj
│   │   ├── Info.plist
│   │   └── SceneDelegate.swift
│   ├── Model
│   │   ├── MockData.swift
│   │   ├── MovieData.swift
│   │   └── ReservationModel.swift
│   ├── Service
│   │   ├── NetworkManager.swift
│   │   └── ReservationService.swift
│   ├── Utils
│   │   └── Observable.swift
│   ├── View
│   │   ├── AuthView
│   │   ├── MovieDetail
│   │   ├── MovieSection
│   │   ├── MyPage
│   │   ├── Reservation
│   │   └── TabBar
│   └── ViewModel
│       ├── APIKey.swift
│       ├── AuthViewModel.swift
│       ├── GoogleService-Info.plist
│       ├── MovieDetailViewModel.swift
│       ├── MovieListViewModel.swift
│       ├── MyPageViewModel.swift
│       ├── ReservateViewModel.swift
│       └── ViewModelProtocol.swift
└── cinema-seat-bandit.xcodeproj
```


## Convention 
### Commit Convention (PR 시 동일하게 적용)
- `feat`: 새로운 기능 추가
- `refactor`: 새로운 기능 추가 없이 개선이 이뤄진 경우(주석 수정, 네이밍 수정 포함)
- `fix`: 버그 수정
- `chore`: 프로젝트 설정, ignore 설정, 패키지 추가 등 코드 외적인 변경 사항
- `docs`: 문서 작업
- `test`: 테스트 관련 작업

###  Coding Convention
- 기본적으로 Swift API Design Guidelines를 기반으로 하거나, Swift Document에 예제로 쓰인 코드 스니펫들을 기준으로 진행
- 파일 생성시 생기는 상단 주석은 삭제
- UI 컴포넌트 네이밍
    - UI 컴포넌트 생성 시, suffix로 컴포넌트 타입 명시
- import 구문
    - Foundation, UIKit 2개는 반드시 맨 위에 작성(소스코드가 어디에 관여하는지 나타내기 때문)
    - 내부 import들을 먼저쓰고, 외부 import들을 밑에 쓴다. (개행은 x)
    - 그 외 순서는 자유롭게
- Extension 파일의 경우는 `{타입}+Extensions.swift` 형태로 작성
    -   ex) Array+Extensions.swift, UIStackView+Extensions.swift

### Branch Convention
- main: 배포 가능한 안정적인 코드가 유지되는 브랜치
- dev: 기본 브랜치로, 기능을 개발하는 브랜치
- {tag}/{#issue-number}-{keyword}
    - ex) feat/#3-category-ui
    - ex) refactor/#5-storage
- {tag}/* 브랜치들은 전부 dev로 PR 발행 후, 팀원 모두의 승인을 받고 merge할 것
- 기본적으로 merge 방식으로 진행, (원하면 rebase해도 상관없음)
- 브랜치는 가급적 소문자로 구성하기!
