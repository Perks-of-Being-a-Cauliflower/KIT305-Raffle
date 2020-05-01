//
//  CreateOptions.swift
//  Tutorial5
//
//  Created by Fiona Colbert on 30/4/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

import Foundation
import UIKit


enum Options {
case name
case desField
case price
case endCon
    


init?(tag: Int) {
  switch tag {
  case 1:
    self = .name
  case 2:
    self = .desField
  case 3:
    self = .price
  case 4:
    self = .endCon
  default:
    return nil
  }
}
    var options: String {
      switch self {
      case .name:
        return "Name:"
      case .desField:
        return "Description:"
      case .price:
        return "Price:"
      case .endCon:
        return "Select End Condition:"
      }
    }
}
