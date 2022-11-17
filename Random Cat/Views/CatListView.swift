//
//  CatListView.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation
import RealmSwift
import SwiftUI

struct CatListView: View {
    @StateObject var realmManager = RealmManager()
    private var bounds: CGRect { UIScreen.main.bounds }
    var body: some View {

        NavigationView {
            VStack {
                List {
                    ForEach(realmManager.cats, id: \.id) { cat in
                        if let image = realmManager.getImageData(from: cat) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: min(300, bounds.width * 0.7), height: min(400, bounds.height * 0.6))
                                .modifier(CenterModifier())
                                .cornerRadius(20)


                        } else {
                            Image(uiImage: UIImage(named: "UnknownImageType")!)
                                .modifier(CenterModifier())
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                    .navigationBarTitle("Saved Cats", displayMode: .large)
                    .navigationBarBackButtonHidden(true)
    
            }
        }
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}
