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
     enum Section: String, CaseIterable {
         case grid = "Grid"
         case main = "Main"
     }
     
     enum Group: Hashable {
         case grid(UIColor)
         case main(SimpsonList)
     }
     
    
    //DataSource 7 DatasourceSnapshot typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Group>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Group>
     
     //Subscripcion con Combine
     private var subscription: AnyCancellable?
     
     //Acceso a mi modelo y ViewModel
     private var viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: MainListViewController.configurationLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

     //Registro de mi celda de la forma mas actualizada
     let gridcell = UICollectionView.CellRegistration<UICollectionViewCell, UIColor> { cell, _, color in
         cell.backgroundColor = color
     }
     
     let listcell = UICollectionView.CellRegistration<UICollectionViewListCell, SimpsonList> { cell, _, model in
         var listcontentConfiguration = UIListContentConfiguration.cell()
         
         listcontentConfiguration.text = model.name.lowercased()
         listcontentConfiguration.image = UIImage(systemName: "star")
         cell.contentConfiguration = listcontentConfiguration }

    
     override func viewDidLoad() {
         super.viewDidLoad()
         setUI()
         bindUI()
         
     }
     
     private func setUI() {
         collectionView.backgroundColor = .white
         viewModel.loadData()
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
     
     lazy var dataSource: DataSource = {
         let datasource = DataSource(collectionView: collectionView) {[unowned self] collectionView, indexPath, item -> UICollectionViewCell in
             switch item {
             case .grid (let color):
                 return collectionView.dequeueConfiguredReusableCell(using: self.gridcell, for: indexPath, item: color)
                 
             case .main(let model):
                 return collectionView.dequeueConfiguredReusableCell(using: self.listcell, for: indexPath, item: model)
             }
         }
         return datasource
     }()
     
     
     //Configuracion de mi snapshot
     private func configurationSnapshot(simpsonList: [SimpsonList]) {
         var snapshot = DataSourceSnapshot()
         
         let list =  (simpsonList.prefix (20))
         let listMain = list.map { simson in
             Group.main(simson)
         }
         let listColor = [UIColor.purple, UIColor.red, UIColor.green, UIColor.brown,UIColor.systemPink,UIColor.systemCyan].map { color in
             Group.grid(color)
         }
        
         snapshot.appendSections(Section.allCases)
         snapshot.appendItems(listMain,toSection: .main)
         snapshot.appendItems(listColor,toSection: .grid)
         
         dataSource.apply(snapshot)
     }
     
     static private func configurationLayout() -> UICollectionViewLayout {
         
         let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
             
             
             let sectionKind = Section.allCases [sectionIndex]
             switch sectionKind {
             case .grid:
                 
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.045),
                                                      heightDimension: .fractionalHeight(0.80))
                 let item = NSCollectionLayoutItem(layoutSize: itemSize)
                 
                 item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                              leading: 5,
                                                              bottom: 0,
                                                              trailing: 0)

                 let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.10))
                 let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                 
                 let section = NSCollectionLayoutSection(group: group)
                 section.orthogonalScrollingBehavior = .continuous
                 return section
                 
             case .main:
                 let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                       heightDimension: .fractionalHeight(1))
                  let item = NSCollectionLayoutItem(layoutSize: itemSize)
                 
                 let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.050))
                 
                 
                 let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                 
                 
                 let section = NSCollectionLayoutSection(group: group)
                 return section
             }
         }
         return layout
     }
}
