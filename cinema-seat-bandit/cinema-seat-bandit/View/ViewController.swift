//
//  ViewController.swift
//  cinema-seat-bandit
//
//  Created by 윤주형 on 4/25/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        loadData()
    }
    func loadData() {
        NetworkManager.shared.request(api: .trending()) {
            (result: Result<TrendingResponse, Error>) in
            switch result {
            case .success(let response):
                print("✅ 트렌딩 성공 - 첫 영화 제목:", response.results.first?.title ?? "없음")
                print("전체 결과 개수:", response.results.count)
            case .failure(let error):
                print("❌ 트렌딩 실패:", error.localizedDescription)
            }
        }
        
    }
    
}

