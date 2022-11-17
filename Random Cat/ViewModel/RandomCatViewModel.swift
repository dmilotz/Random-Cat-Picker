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
    
    private static let decoder = JSONDecoder()
    var subscription: AnyCancellable?
    
    @Published public var fetching = false
    @Published var randomCat: RandomCat = RandomCat() {
        didSet {
            loadImage()
        }
    }
    
    @Published public var backgroundColor = Color(white: 0.4745)
    @Published public var decisionState = DecisionState.undecided
    @Published var image: UIImage?
    @Published var networkError: Bool = false
    
    // Subscriber implementation
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
                           .map { UIImage(data: $0.data) }   // 2
                           .replaceError(with: nil)          // 3
                           .receive(on: DispatchQueue.main)  // 4
                           .assign(to: \.image, on: self)    // 5
    }
    

    public func updateBackgroundColorForTranslation(_ translation: Double) {
        switch translation {
        case ...(-0.5):
            backgroundColor = Color("Red")
        case 0.5...:
            backgroundColor = Color("Green")
        default:
            backgroundColor = Color("Gray")
        }
    }
    
    public func updateDecisionStateForTranslation(
        _ translation: Double,
        andPredictedEndLocationX x: CGFloat,
        inBounds bounds: CGRect) {
            switch (translation, x) {
            case (...(-0.2), ..<0):
                decisionState = .disliked
            case (0.2..., bounds.width...):
                decisionState = .liked
            default:
                decisionState = .undecided
            }
        }
    
    public func reset() {
        image = nil
    }
}
