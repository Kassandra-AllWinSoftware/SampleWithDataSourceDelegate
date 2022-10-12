//
//  MainListViewController.swift
//  CollectionView-Layout
//
//  Created by User-XB02 on 10/10/22.
//
import UIKit
import Combine

 class MainListViewController: UICollectionViewController {
     
     //Cantidad de secciones que tendra el collectionView
     enum Section: CaseIterable {
         case main
     }
    
    //DataSource 7 DatasourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SimpsonList>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, SimpsonList>
     
     //Subscripcion con Combine
     private var subscription: AnyCancellable?
     //Acceso a mi modelo y ViewModel
     var listData = [SimpsonList]()
     private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: Self.configurationLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     //Registro de mi celda de la forma mas actualizada
     let listcell = UICollectionView.CellRegistration<UICollectionViewListCell, SimpsonList> { cell, indexPath, model in
         var listcontentConfiguration = UIListContentConfiguration.cell()
         listcontentConfiguration.text = model.name.lowercased()
         cell.contentConfiguration = listcontentConfiguration }
    
    lazy var dataSource: DataSource = {
        let datasource = DataSource(collectionView: collectionView) { collectionView, indexPath, model -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: self.listcell, for: indexPath, item: model)
        }
        return datasource
    }()
    
     override func viewDidLoad() {
         super.viewDidLoad()
         viewModel.loadData()
         bindUI()
     }
     
     //Capturando mis datos mediante el uso de combine.
     private func bindUI() {
         subscription = viewModel.listSubject.sink { completion in
             switch completion {
             case .finished:
                 print("Completado")
             case .failure(let error):
                 print(error.localizedDescription)
             }
         } receiveValue: { [unowned self]  simson in
             self.configurationSnapshot(simpsonList: simson)
         }
     }
     
     //Configuracion de mi snapshot
     private func configurationSnapshot(simpsonList: [SimpsonList]) {
         var snapshot = DataSourceSnapshot()
         snapshot.appendSections(Section.allCases)
         snapshot.appendItems(simpsonList)
         Section.allCases.forEach { snapshot.appendItems(listData, toSection: $0)
         }
         dataSource.apply(snapshot)
     }
     
     static private func configurationLayout() -> UICollectionViewLayout {
         let config = UICollectionLayoutListConfiguration(appearance: .grouped)
         let layout = UICollectionViewCompositionalLayout.list(using: config)
         
         return layout
     }
}
