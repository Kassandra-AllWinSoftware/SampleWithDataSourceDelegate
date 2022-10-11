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
        super.init(collectionViewLayout: MainListViewController.layout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let funcion = { (fecheando: [SimpsonList]) in
            DispatchQueue.main.async {
                self.listData = fecheando
                self.collectionView.reloadData()
            }
        }
        APIListSimpson.shared.ListFetchList(completion: funcion)
    
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
    
    //Aspecto de como se mostrara la lista
    private static func layout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        return UICollectionViewCompositionalLayout.list(using: config)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let configType = self.registerListCell
        return collectionView.dequeueConfiguredReusableCell(using: configType, for: indexPath, item: listData[indexPath.row])
    }
}
