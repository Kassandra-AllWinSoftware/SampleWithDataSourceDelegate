//
//  Coordinator.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var model: Any? { get set }
    var navigationController: UINavigationController? { get set }
    func start()
}

extension Coordinator {
    
    func inject(model: Any?) {
        self.model = model
    }
    
    func inject(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

