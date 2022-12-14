//
//  DiffableCollectionViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/19.
//

import UIKit

import RxCocoa
import RxSwift
import Kingfisher


class DiffableCollectionViewController: UIViewController {

    // MARK: - Propertys
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel = DiffableViewModel()
    
    // Int : Section 정보
    // String : Row마다 들어갈 데이터
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!
    
    private let disposeBag = DisposeBag()
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        setDelegate()
        bindData()
    }
    
    
    
    
    // MARK: - Methods
    private func bindData() {
//        viewModel.photoList.bind { photo in
//            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
//            snapshot.appendSections([0])
//            snapshot.appendItems(photo.results)
//            self.dataSource.apply(snapshot)
//        }
        
        viewModel.photoList
            .withUnretained(self)
            .subscribe { (vc, photo) in
                var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
                snapshot.appendSections([0])
                snapshot.appendItems(photo.results)
                vc.dataSource.apply(snapshot)
            } onError: { error in
                print("=====ERROR : \(error)")
            } onCompleted: {
                print("Completed")
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag)

        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe { (vc, value) in
                vc.viewModel.requestSearchPhoto(query: value)
            }
            .disposed(by: disposeBag)
    }
    
    
    private func setDelegate() {
        collectionView.delegate = self
        //searchBar.delegate = self
    }
}




// MARK: - CollectionView Layout, Datasource
extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        config.showsSeparators = false
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SearchResult> { cell, indexPath, itemIdentifier in
            
            // Content Configuration
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            DispatchQueue.global().async {
                guard let url = URL(string: itemIdentifier.urls.thumb),
                      let data = try? Data(contentsOf: url)
                else { return }
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data)
                    
                    cell.contentConfiguration = content   // 비동기로 이미지 데이터를 가져온 후, content 등록
                }
            }
            
            
            // Background Configuration
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 3
            background.strokeColor = .green
            cell.backgroundConfiguration = background
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
    }
}




// MARK: - CollectionView Delegate
extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // id
        let id = viewModel.fetchPhotoID(at: indexPath.item)
        APIService.getPhoto(id: id) { photo, statusCode, error in
            if let error {
                print(error.localizedDescription)
                print("\(statusCode)")
            }
            
            if let photo {
                print("SUCCESS --")
            }
        }
        
        
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alert = UIAlertController(title: "좋아요 수", message: "\(item.likes)개", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        present(alert, animated: true)
    }
}




// MARK: - SearchBar Protocol
//extension DiffableCollectionViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        viewModel.requestSearchPhoto(query: searchBar.text ?? "")
//    }
//}
