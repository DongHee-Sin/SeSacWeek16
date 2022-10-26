//
//  RXTableViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa


final class RXTableViewController: BaseViewController {

    // MARK: - Propertys
    let datas = BehaviorSubject(value: [
        RXUser(name: "jack", age: 23),
        RXUser(name: "hue", age: 19),
        RXUser(name: "dong", age: 25),
        RXUser(name: "chan", age: 29)
    ])
    
    var dataSource: UITableViewDiffableDataSource<Int, RXUser>!
    
    
    
    
    // MARK: - LifeCycle
    let rxTableView = RXTableView()
    override func loadView() {
        view = rxTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        configureDataSource()
        dataBind()
        addButtonAction()
    }
    
    
    private func configureDataSource() {
        rxTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "rxtvCell")
        
        dataSource = UITableViewDiffableDataSource<Int, RXUser>(tableView: rxTableView.tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "rxtvCell")
            cell?.textLabel?.text = itemIdentifier.name
            cell?.accessibilityLabel = "\(itemIdentifier.age)"
            cell?.selectionStyle = .none
            return cell
        })
    }
    
    
    private func dataBind() {
        datas.bind { [weak self] values in
            var snapshot = NSDiffableDataSourceSnapshot<Int, RXUser>()
            snapshot.appendSections([0])
            snapshot.appendItems(values)
            self?.dataSource.apply(snapshot)
        }
        .disposed(by: disposeBag)
        
        
        rxTableView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { (vc, index) in
                guard let datas = try? vc.datas.value() else { return }
                let data = datas[index.row]
                print("\(data.name) : \(data.age)")
            }
            .disposed(by: disposeBag)
    }
    
    
    private func addButtonAction() {
        rxTableView.addCellButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                var datas = (try? vc.datas.value()) ?? []
                datas.append(RXUser(name: "추가", age: .random(in: 1...50)))
                vc.datas.onNext(datas)
            }
            .disposed(by: disposeBag)
    }
}
