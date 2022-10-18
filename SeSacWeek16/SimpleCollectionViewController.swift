//
//  SimpleCollectionViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/18.
//

import UIKit


struct User {
    let name: String
    let age: Int
}


class SimpleCollectionViewController: UICollectionViewController {

    // MARK: - Propertys
//    var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메치킨"]
    var list = [
        User(name: "뽀로로", age: 3),
        User(name: "에디", age: 2),
        User(name: "해리포터", age: 23),
        User(name: "도라이몽", age: 12)
    ]
    
    
    // https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    // cellForItemAt 전에 생성되어야 한다. (register 코드와 유사한 역할)
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS 14+ : 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        
        // list 형태로 CollectionView Layout 생성
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        
        // Handler : cellForItemAt에서 dequeueConfiguredReusableCell의 매개변수로 제공할 Registration을 정의(?)
        // cell의 속성을 여기서 정의
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            //var content = cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name    // let item = list[indexPath.row] 부분을 가져오는 것
            content.textProperties.numberOfLines = 1
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살"
            content.prefersSideBySideTextAndSecondaryText = false
            content.textToSecondaryTextVerticalPadding = 10
            content.secondaryTextProperties.font = .systemFont(ofSize: 11)
            
            content.image = itemIdentifier.age < 10 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star.fill")
            content.imageProperties.tintColor = .brown
            
            cell.contentConfiguration = content
        }
    }
    
}




// MARK: - CollectionView Methods
extension SimpleCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.row]
        
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }
    
}
