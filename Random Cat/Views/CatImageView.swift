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
  
  var body: some View {
    ZStack {
    
      VStack(alignment: .leading, spacing: 20) {
          if let image = viewModel.image {
              Image(uiImage: image)
                  .aspectRatio(contentMode: .fit)

          } else {
              ProgressView()
          }
      }
      
      .padding(20)
      .cornerRadius(20)
    }
    .frame(width: min(300, bounds.width * 0.7), height: min(400, bounds.height * 0.6))
      
  }
  
  private var bounds: CGRect { UIScreen.main.bounds }
  
  private var repeatingAnimation: Animation {
    Animation.linear(duration: 1)
      .repeatForever()
  }
}

struct CatImageView_Previews: PreviewProvider {
  static var previews: some View {
    CatImageView(viewModel: CatViewModel())
      .previewLayout(.sizeThatFits)
  }
}
