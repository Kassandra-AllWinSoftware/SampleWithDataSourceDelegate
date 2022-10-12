//
//  ListViewModel.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//

import Foundation
import Combine

final class ListViewModel {
    
    var listData = [SimpsonList]()
    let listSubject = PassthroughSubject<[SimpsonList], Error>()
    private var fetched = [SimpsonList]() {
        didSet {
            listSubject.send(fetched)
        }
    }
    
    func loadData() {
        let completion = { (dataList: [SimpsonList]) in
            DispatchQueue.main.async { [unowned self] in
                listSubject.send(dataList)
            }
        }
        APIListSimpson.shared.listFetchList(completion: completion)
    }
}


