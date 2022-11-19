//
//  CatImageView.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation

import SwiftUI

struct CatImageView: View {
    @ObservedObject var viewModel: CatViewModel
    private var bounds: CGRect { UIScreen.main.bounds }
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 20) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.2)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .animation(.easeInOut)
                    
                } else {
                    ProgressView()
                }
            }
            
            .padding(20)
            .cornerRadius(20)
        }
        .frame(width: min(300, bounds.width * 0.7), height: min(400, bounds.height * 0.6))
        
    }
    
}

struct CatImageView_Previews: PreviewProvider {
    static var previews: some View {
        CatImageView(viewModel: CatViewModel())
            .previewLayout(.sizeThatFits)
    }
}
