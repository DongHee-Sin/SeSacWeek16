//
//  SimpleCollectionViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit


struct User: Hashable {
    // 모든 프로퍼티가 같아야 .. 같은건데 UUID는 모두 다른값을 주니까 고유해지는 것
    let id = UUID().uuidString   // 한번 찾아보기!
    let name: String
    let age: Int
}


class SimpleCollectionViewController: UICollectionViewController {

    // MARK: - Propertys
    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메치킨"]
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 2),
        User(name: "해리포터", age: 23),
        User(name: "도라이몽", age: 12)
    ]
    
    
    // https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성되어야 한다. (register 코드와 유사한 역할)
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        
        // 1. Identifier 불필요, 2. 구조체 단위로 셀에 대한 등록
        
        // Handler : cellForItemAt에서 dequeueConfiguredReusableCell의 매개변수로 제공할 Registration을 정의(?)
        // cell의 속성을 여기서 정의
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            // Content Config : Cell에 담긴 뷰객체들에 대한 처리
            var content = UIListContentConfiguration.valueCell()
            
            content.text = itemIdentifier.name    // let item = list[indexPath.row] 부분을 가져오는 것
            content.textProperties.numberOfLines = 1
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 10
            content.secondaryTextProperties.font = .systemFont(ofSize: 11)
            
            content.image = itemIdentifier.age < 10 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .brown
            
            
            // Background Config : Cell의 배경 View(root view)에 대한 처리
            // 어떤 속성인지에 따라 background config에 적용되는 방식이 달라질 수 있음 (plain, insetGroup...)
            var background = UIBackgroundConfiguration.listPlainCell()
            
            background.backgroundColor = .lightGray
            background.cornerRadius = 30
            background.strokeColor = .systemPink
            background.strokeWidth = 2
            
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = background
        }
        
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)

            return cell
        })
        
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
    
}




// MARK: -
extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        // list 형태로 CollectionView Layout 생성
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
}
