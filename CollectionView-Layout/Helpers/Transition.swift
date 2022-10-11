//
//  Transition.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import Foundation

protocol TransitionDelegate: AnyObject {
    func process(transition: Transition, with model: Any?)
}

enum Transition {
    case mainListView
    case detailView
}
