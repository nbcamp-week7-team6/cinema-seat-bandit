//
//  ReservationViewController.swift
//  cinema-seat-bandit
//
//  Created by GO on 4/30/25.
//

import UIKit

class ReservationViewController: UIViewController {

    private let firstProcess = FirstReserveView()
    private let secondProcess = SecondReserveView()
    private let thirdProcess = ThirdReserveView()
    private let finalProcess = FinalReserveView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }

}
