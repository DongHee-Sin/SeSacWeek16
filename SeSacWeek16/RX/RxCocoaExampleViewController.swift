//
//  RxCocoaExampleViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift


final class RxCocoaExampleViewController: UIViewController {

    // MARK: - Propertys
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    private var disposeBag = DisposeBag()
    
    private var nickname = Observable.just("Jack")
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
        
//        nickname
//            .bind(to: nicknameLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "Hello"
//        }
    }
    
    // ViewController가 deinit 되면, 알아서 disposed도 동작한다.
    deinit {
        print("RXCocoaExampleViewController DEINIT!!!")
    }
    
    
    
    
    // MARK: - TableView
    private func setTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        
        // Infinite Observable Sequences
//        tableView.rx.modelSelected(String.self)
//            .map { "\($0) 를 클릭했습니다." }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
        tableView.rx.modelDeselected(String.self)
            .map { "\($0) 선택 해제" }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        
        // subscribe로 onNext만 정의하면 위에서 작성한 bind와 같은 결과
//        tableView.rx.modelSelected(String.self)
//            .subscribe { value in
//                print(value)    // onNext
//            } onError: { error in
//                print(error)
//            } onCompleted: {
//                print("completed")
//            } onDisposed: {
//                print("disposed")  // 메모리 정리
//            }
//            .disposed(by: disposeBag)

    }
    
    
    // MARK: - PickerView
    private func setPickerView() {
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return "\(row+1) : \(element)"
            }
            .disposed(by: disposeBag)
        
        
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)

    }
    
    
    // MARK: - Switch
    private func setSwitch() {
        Observable.of(false)
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Sign
    private func setSign() {
        // ex. 텍1(Observable), 텍2(Observable) => Label(Observer, Bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, email은 \(value2) 입니다."
        }
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
        
        
        signName                 // UITextField
            .rx                  // Reactive
            .text                // String?
            .orEmpty             // String
            .map { $0.count }    // Int
            .map { $0 < 4 }      // Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail
            .rx
            .text
            .orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        signButton
            .rx
            .tap
            .withUnretained(self)
            .subscribe { vc, _ in    // 왜 subscribe쓰지? : 반환값이 Void라서 bind를 굳이 사용할 필요 없음
                vc.showAlert()                   // bind는 나온 데이터를 어딘가에 할당(?)해주는 느낌..?
            }
            .disposed(by: disposeBag)
    }
    
    
    // MARK: - Operator
    private func setOperator() {
        
        Observable.repeatElement("Jack")      // 반복 (Infinite Obserable Sequence)
            .take(5)                          // 반복 횟수 제한
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        
        
        // 무한 시퀸스
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        
        
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)              // just :
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)

        Observable.of(itemsA, itemsB)        // of : 가변매개변수 사용
            .subscribe { value in
                print("of - \(value)")       // 가변 매개변수로 입력된 개수만큼 실행
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)               // from : 시퀸스를 순환한 후, completed 실행
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    
    private func showAlert() {
        let alert = UIAlertController(title: "ㅎㅎ", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
