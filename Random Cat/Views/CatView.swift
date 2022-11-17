//
//  CatView.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import SwiftUI
import RealmSwift

struct CatView: View {
    @State var kittySaved: Bool = false
    @StateObject var realmManager = RealmManager()
    @ObservedObject private var viewModel = CatViewModel()
    @State private var showCatView = false
    @State private var showFetchingCat = false
    @State private var cardTranslation: CGSize = .zero
    @State private var hudOpacity = 0.5
    @State private var presentSavedCats = false
    
    private var bounds: CGRect { UIScreen.main.bounds }
    private var translation: Double { Double(cardTranslation.width / bounds.width) }
    private var circleDiameter: CGFloat { bounds.width * 0.9 }
    
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                  Spacer()
                    catImageView
                        .opacity(showCatView ? 1 : 0)
                        .offset(y: showCatView ? 0.0 : -bounds.height)
                    
                    Spacer()
                    RoundedButton(title: "Show Liked Cats") {
                        self.presentSavedCats = true
                    }
                    .padding(20)
                    .sheet(isPresented: $presentSavedCats) {
                        CatListView()
                    }
                }
                .navigationBarTitle("Random Cat Picker")
            }
            
            HStack {
                ProgressView()
                    .animation(.linear(duration: 1)
                        .repeatForever(autoreverses: false), value: showFetchingCat)
            }
            .frame(alignment: .center)
            .opacity(showFetchingCat ? 1 : 0)
            .alert("Kitty picture was saved!", isPresented: $kittySaved) {
                        Button("OK", role: .cancel) { }
                    }
            .alert("Network Error! Check your connection and try again.", isPresented: $viewModel.networkError) {
                Button("OK", role: .cancel) { }
            }
        }
        .onAppear(perform: {
            self.reset()
        })
    }
    
    private var catImageView: some View {
        CatImageView(viewModel: viewModel)
            .background(viewModel.backgroundColor)
            .cornerRadius(20)
            .shadow(radius: 10)
            .rotationEffect(rotationAngle)
            .offset(x: cardTranslation.width, y: cardTranslation.height)
            .animation(.spring(response: 0.5, dampingFraction: 0.4, blendDuration: 2))
            .gesture(
                DragGesture()
                    .onChanged { change in
                        self.cardTranslation = change.translation
                        self.updateBackgroundColor()
                    }
                    .onEnded { change in
                        self.updateDecisionStateForChange(change)
                        self.handle(change)
                    }
            )
    }
    
    private var rotationAngle: Angle {
        return Angle(degrees: 75 * translation)
    }
    
    private func updateDecisionStateForChange(_ change: DragGesture.Value) {
        viewModel.updateDecisionStateForTranslation(
            translation,
            andPredictedEndLocationX: change.predictedEndLocation.x,
            inBounds: bounds
        )
    }
    
    private func updateBackgroundColor() {
        viewModel.updateBackgroundColorForTranslation(translation)
    }
    
    private func handle(_ change: DragGesture.Value) {
        let decisionState = viewModel.decisionState
        
        switch decisionState {
        case .undecided:
            kittySaved = false
            cardTranslation = .zero
            self.viewModel.reset()
        default:
            if decisionState == .liked {
                realmManager.addCat(newCat: viewModel.randomCat, imageToBeAdded: viewModel.image)
                kittySaved = true
            }
            
            let translation = change.translation
            let offset = (decisionState == .liked ? 2 : -2) * bounds.width
            cardTranslation = CGSize(
                width: translation.width + offset,
                height: translation.height
            )
            showCatView = false
            reset()
        }
    }
    
    private func reset() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showFetchingCat = true
            self.hudOpacity = 0.5
            self.cardTranslation = .zero
            self.viewModel.reset()
            self.viewModel.fetchCat()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showFetchingCat = false
                self.showCatView = true
                self.hudOpacity = 0
            }
        }
    }
}

#if DEBUG
struct CatView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CatView()
                .previewDevice("iPhone 11 Pro Max")
                .previewDisplayName("iPhone Xs Max")
            
            CatView()
                .previewDevice("iPhone SE (2nd generation)")
                .previewDisplayName("iPhone SE (2nd generation)")
                .environment(\.colorScheme, .dark)
        }
    }
}
#endif

