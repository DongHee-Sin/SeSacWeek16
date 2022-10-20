//
//  NewsViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/20.
//

import UIKit


final class NewsViewController: UIViewController {

    // MARK: - Propertys
    private let viewModel = NewsViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, News.NewsItem>!
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        configureDataSource()
        bind()
        addTarget()
    }
    
    
    
    
    // MARK: - Methdos
    private func addTarget() {
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    
    private func bind() {
        viewModel.pageNumber.bind { value in
            self.numberTextField.text = value
        }
        
        viewModel.news.bind { items in
            var snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>()
            snapshot.appendSections([0])
            snapshot.appendItems(items)
            self.dataSource.apply(snapshot, animatingDifferences: false)   // dataSource 프로퍼티 초기화 후 실행해야 함
        }
    }
    
    
    
    
    // MARK: - Objc Methods
    @objc private func numberTextFieldChanged() {
        guard let text = numberTextField.text else { return }
        viewModel.changePageNumberFormat(text: text)
    }
    
    
    @objc private func loadButtonTapped() {
        viewModel.loadNews()
    }
    
    
    @objc private func resetButtonTapped() {
        viewModel.resetNews()
    }
}




// MARK: - CollectionView Methods
extension NewsViewController {
    
    func configureHierachy() {   // addSubView, init, snapkit 등
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            content.secondaryText = itemIdentifier.body
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
    
}
