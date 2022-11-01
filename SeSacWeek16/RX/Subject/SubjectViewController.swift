//
//  SubjectViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/25.
//

import UIKit

import RxCocoa
import RxSwift


final class SubjectViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    // MARK: - Propertys
    private let viewModel = SubjectViewModel()
    
    private let disposeBag = DisposeBag()
    
    let publish = PublishSubject<Int>()         // 초가값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100)  // 초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3)  // bufferSize에 작성된 이벤트 개수만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트를 전달
    let asyncSbj = AsyncSubject<Int>()
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContackCell")
        
        
        // MARK: - Input Output
        let input = SubjectViewModel.Input(addTap: addButton.rx.tap, resetTap: resetButton.rx.tap, newTap: newButton.rx.tap, searchText: searchBar.rx.text)
        let output = viewModel.transfrom(input: input)
        
        
        output.list
            .drive(tableView.rx.items(cellIdentifier: "ContackCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name) : \(element.age)세 : \(element.number)"
            }
            .disposed(by: disposeBag)
        
        
        // VC -> VM (Input)
        output.addTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        output.resetTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        output.newTap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        output.searchText
            .withUnretained(self)
            .subscribe { (vc, query) in
                print("======\(query)")
                vc.viewModel.filterData(query: query)
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    // MARK: - Methods
    func subjectTest() {
        publishSubject()
        behaviorSubject()
        replaySubject()
        asyncSubject()
    }
}




// MARK: - Subject 4종류 테스트
extension SubjectViewController {
    
    // MARK: - PublishSubject
    private func publishSubject() {
        // 초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후의 이벤트는 무시
        // subscribe 후에 대한 이벤트는 다 처리
        
        publish.onNext(1)
        publish.onNext(2)
        
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish - completed")
            } onDisposed: {
                print("publish - disposed")
            }
            .disposed(by: disposeBag)

        
        // 구독 후 이벤트만 발생
        publish.onNext(3)
        publish.onNext(4)
        publish.on(.next(5))
        
        publish.onCompleted()
        
        publish.onNext(6)
        publish.onNext(7)
    }
    
    
    
    // MARK: - BehaviorSubject
    private func behaviorSubject() {
        // 구독 전의 가장 최근 값을 같이 emit
        // 바로 이전의 것만 의미있음
        
        // behavior.onNext(1)
        // behavior.onNext(2)
        
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior - completed")
            } onDisposed: {
                print("behavior - disposed")
            }
            .disposed(by: disposeBag)

        
        // 구독 후 이벤트만 발생
        behavior.onNext(3)
        behavior.onNext(4)
        behavior.on(.next(5))
        
        behavior.onCompleted()
        
        behavior.onNext(6)
        behavior.onNext(7)
    }
    
    
    
    // MARK: - replaySubject
    private func replaySubject() {
        // BufferSize는 메모리에 저장
        // 배열이나 이미지같은걸 너무 많이 Buffer에 저장한다면 좋지 않음
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)

        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay - completed")
            } onDisposed: {
                print("replay - disposed")
            }
            .disposed(by: disposeBag)

        
        // 구독 후 이벤트만 발생
        replay.onNext(3)
        replay.onNext(4)
        replay.on(.next(5))
        
        replay.onCompleted()
        
        replay.onNext(6)
        replay.onNext(7)
    }
    
    
    
    // MARK: - asyncSubject
    private func asyncSubject() {
        asyncSbj.onNext(100)
        asyncSbj.onNext(200)
        asyncSbj.onNext(300)
        asyncSbj.onNext(400)
        asyncSbj.onNext(500)

        
        asyncSbj
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async - completed")
            } onDisposed: {
                print("async - disposed")
            }
            .disposed(by: disposeBag)

        
        // 구독 후 이벤트만 발생
        asyncSbj.onNext(3)
        asyncSbj.onNext(4)
        asyncSbj.on(.next(5))
        
        //async.onCompleted()
        
        asyncSbj.onNext(6)
        asyncSbj.onNext(7)
    }
    
}
