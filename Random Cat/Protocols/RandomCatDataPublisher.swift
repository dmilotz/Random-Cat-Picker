//
//  RandomCatDataPublisher.swift
//  Random Cat
//
//  Created by Dirk Milotz on 11/16/22.
//

import Foundation

import Foundation
import Combine

public protocol RandomCatDataPublisher {
  func publisher() -> AnyPublisher<Data, URLError>
}
