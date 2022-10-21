//
//  ShoppingListViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/21.
//

import UIKit

final class ShoppingListViewController: UIViewController {

    // MARK: - Propertys
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = ShoppingListViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Shopping>!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    
    
    
    // MARK: - Methods
    private func configure() {
        searchBar.delegate = self
        
        collectionView.delegate = self
        configureDataSource()
        
        collectionView.collectionViewLayout = createLayout()
        
        bind()
    }
    
    
    private func bind() {
        viewModel.shoppingList.bind { [weak self] list in
            guard let self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Int, Shopping>()
            snapshot.appendSections([0])
            snapshot.appendItems(self.viewModel.shoppingList.value)
            self.dataSource.apply(snapshot)
        }
    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { _, _, _ in
                self?.viewModel.removeShopping(at: indexPath.item)
            }
            return .init(actions: [deleteAction])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}



// MARK: - CollectionView Datasource
extension ShoppingListViewController {
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Shopping> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.title) : \(itemIdentifier.importance.rawValue)"
            content.secondaryText = "\(itemIdentifier.price)원"
            content.prefersSideBySideTextAndSecondaryText = false
            
            cell.contentConfiguration = content
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
}




// MARK: - CollectionView Delegate
extension ShoppingListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)")
    }
    
}




// MARK: - SearchBar Delegate
extension ShoppingListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let task = Shopping(title: searchBar.text!, price: 1004, importance: .normal)
        viewModel.addShopping(shopping: task)
    }
}
