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
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: bounds.width * 0.7, height:  bounds.height * 0.6)
                                    .modifier(CenterModifier())
                                    .cornerRadius(20)
                                
                                ShareLink(item: Image(uiImage: image), preview: SharePreview("", image: Image(uiImage: image))) {
                                    Text("Share kitty with friends!")
                                }
                           
                            }
                        } else {
                            Image(uiImage: UIImage(named: "UnknownImageType")!)
                                .modifier(CenterModifier())
                        }
                        
                    }
                    
                }
                .listStyle(GroupedListStyle())
                    .navigationBarTitle("Liked Cats", displayMode: .large)
                    .navigationBarBackButtonHidden(false)

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
