//
//  LikedDislikeView.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/17/22.
//

import Foundation
import SwiftUI
struct LikedDislikeView: View {
  enum ImageType {
    case like, dislike
  }
  
  let imageType: ImageType
  
  var body: some View {
    
    image(for: imageType)
      .background(Color.clear)
  }
  
  private func image(for type: ImageType) -> Image {
    let image: UIImage
    
    switch imageType {
    case .like:
      image = UIImage(systemName: "heart.fill")!
    case .dislike:
        image = UIImage(systemName: "hand.thumbsdown.fill")!
    }
    
    return Image(uiImage: image)
  }
}
