//
//  MainListViewController.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//
import UIKit


final class MainListViewController: UICollectionViewController {
    var listData = [SimpsonList]()
    
    init() {
        //Aspecto de como se mostrara la lista
        var layout: UICollectionViewLayout {
            let config = UICollectionLayoutListConfiguration(appearance: .grouped)
            return UICollectionViewCompositionalLayout.list(using: config)
        }
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let completion = { (dataList: [SimpsonList]) in
            DispatchQueue.main.async { [weak self] in
                self?.listData = dataList
                self?.collectionView.reloadData()
            }
        }
        APIListSimpson.shared.listFetchList(completion: completion)
    }
    
    private let registerListCell = UICollectionView.CellRegistration<UICollectionViewListCell, SimpsonList> { cell, _, item in
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.name.lowercased()
        cell.contentConfiguration = configuration
      }
    
    //Cantidad de secciones que tendra la lista
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueConfiguredReusableCell(using: registerListCell, for: indexPath, item: listData[indexPath.row])
    }
}
