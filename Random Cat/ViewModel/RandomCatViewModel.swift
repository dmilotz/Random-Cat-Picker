//
//  RandomCatViewModel.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation

import UIKit
import Combine
import SwiftUI

public final class CatViewModel: ObservableObject {
    public enum DecisionState {
        case disliked, undecided, liked
    }
    
    var subscription: AnyCancellable?
    
    @Published public var fetching = false
    @Published var randomCat: RandomCat = RandomCat() {
        didSet {
            loadImage()
        }
    }
    
    @Published public var decisionState = DecisionState.undecided
    @Published var image: UIImage?
    @Published var networkError: Bool = false
    @Published var networkMonitor = Monitor() {
        didSet {
            if !networkMonitor.isConnected {
                networkError = true
            } else {
                networkError = false
            }
        }
    }
    
    func fetchCat() {
        subscription = RandomCatApi.requestRandomCat()
            .mapError({ (error) -> Error in
                self.networkError = true
                return error
            })
            .sink(receiveCompletion: { _ in },
                  receiveValue: {
                self.randomCat = $0
            })
    }
    
    func loadImage() {
        guard let url = randomCat.catImageUrl else {
            networkError = true
            return
        }
        
        subscription = URLSession.shared
            .dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    public func updateDecisionStateForTranslation(
        _ translation: Double,
        andPredictedEndLocationX x: CGFloat,
        inBounds bounds: CGRect) {
            switch (translation, x) {
            case (...(-0.6), ..<0):
                decisionState = .disliked
            case (0.6..., bounds.width...):
                decisionState = .liked
            default:
                decisionState = .undecided
            }
        }
    
    public func reset() {
        image = nil
    }
}
