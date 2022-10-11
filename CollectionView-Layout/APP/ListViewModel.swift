//
//  ListViewModel.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import Foundation
import Combine

final class ListViewModel {
    weak var transitionDelegate: TransitionDelegate?
    let list = PassthroughSubject <[SimpsonList], Error>()
    private var cancellables = Set <AnyCancellable>()
//    private let store: SimpsonList
//
//    init(_: store =  SimpsonList){
//        store = store
//    }
    
    
    func loadData() {
        let receive = { [unowned self] (data: [SimpsonList]) -> Void in
            DispatchQueue.main.async {
                list.send(data)
            }
        }
        let completion = { [unowned self] (completion: Subscribers.Completion <Error>) -> Void in
            switch  completion {
                case .finished:
                    break
                case .failure(let failure):
                    list.send(completion: .failure(failure))
            }
        }
        
        
    }
}
