//
//  SubscribeViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit

import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources


class SubscribeViewController: UIViewController {
    
    // MARK: - Propertys
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> { dataSource, tableView, indexPath, item in
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
    }
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRXAlamofire()
        testRXDataSource()
        //bind()
    }
    
    
    
    
    // MARK: - RXAlamofire
    /// 에러가 발생하면 구독 종료 -> dispose된다.
    /// 필요하면 다시 구독해야 함.
    /// onError에서 에러 대응이 필요함
    /// "Single" : 네트워크의 성공과 실패를 관리하는 코드에 사용 (키워드)
    private func testRXAlamofire() {
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe { value in
                print(value.results[0].likes)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    // MARK: - RXDataSource
    private func testRXDataSource() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title", items: [1, 2, 3])
            ])
                .bind(to: tableView.rx.items(dataSource: dataSource))
                .disposed(by: disposeBag)
    }
    
    
    
    
    // MARK: - Bind
    private func bind() {
        // MARK: - 버튼 탭 > 레이블 : "안녕 반가워" (다양한 방법)
        let sample = button.rx.tap
        
        // 1. subscribe
        sample
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        
        // 2. 네트워크 통신이나 파일 다운로드 등 백그라운드 작업이 수행된다면?
        button.rx.tap
            .map {}
            .map {}  // 여기까진 global 스레드
            .observe(on: MainScheduler.instance)  // 다른 스레드로 동작하게 변경 가능 (main)
            .map {}  // observe(on:) 에서 설정한 스레드
            .map {}
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        
        // 3. bind : subscribe가 내부적으로 있음, mainSchedular(main스레드)에서 동작, error가 만약 발생하면 런타임에러
        button.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        
        
        // 4. Operator로 데이터의 stream(흐름) 조작
        button
            .rx
            .tap
            .map { return "안녕 반가워" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        
        // 5. driver traits : bind + stream 공유(리소스 낭비를 방지, share())
        button.rx.tap
            .map { "안녕 반가워" }
            .asDriver(onErrorJustReturn: "")  // 에러가 발생하면 나올 문구를 작성(?)
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        
        
        
        // MARK: - debug (디버깅용 코드)
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3)
            .filter { $0 % 2 == 0 }
            .debug()
            .map { $0 * 2 }
            .subscribe { value in
                print("=== \(value)")
            }
            .disposed(by: disposeBag)
    }
}
