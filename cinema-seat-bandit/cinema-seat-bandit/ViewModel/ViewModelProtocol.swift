//
//  ViewModelProtocol.swift
//  cinema-seat-bandit
//
//  Created by shinyoungkim on 4/30/25.
//

import Foundation

protocol ViewModelProtocol: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
