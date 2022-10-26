//
//  SimplePickerViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa


final class SimplePickerViewController: BaseViewController {

    // MARK: - Propertys
    private let pickerData1 = [1, 2, 3, 4]
    private let pickerData2 = ["가", "나", "다", "라"]
    private let pickerData3 = [1.1, 2.2, 3.3, 4.4]
    
    
    
    
    // MARK: - LifeCycle
    let simplePickerView = SimplePickerView()
    override func loadView() {
        view = simplePickerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    
    // MARK: - Methods
    override func configure() {
        dataBind()
        setPickerSelection()
    }
    
    
    private func dataBind() {
        Observable.just(pickerData1)
            .bind(to: simplePickerView.pickerView1.rx.itemTitles) { index, item in
                return "\(index) : \(item)"
            }
            .disposed(by: disposeBag)
        
        Observable.just(pickerData2)
            .bind(to: simplePickerView.pickerView2.rx.itemTitles) {
                return "\($0) => \($1)"
            }
            .disposed(by: disposeBag)
        
        Observable.just(pickerData3)
            .bind(to: simplePickerView.pickerView3.rx.itemTitles) { "\($0), \($1)" }
            .disposed(by: disposeBag)
    }
    
    
    private func setPickerSelection() {
        simplePickerView.pickerView1.rx
            .modelSelected(Int.self)
            .subscribe { value in
                print("picker1 === \(value.debugDescription)")
            }
            .disposed(by: disposeBag)
        
        simplePickerView.pickerView2.rx
            .modelSelected(String.self)
            .bind { value in
                print("picker2 === \(value.description)")
            }
            .disposed(by: disposeBag)
        
        simplePickerView.pickerView3.rx
            .modelSelected(Double.self)
            .map { "picker3 === \($0)" }
            .bind(to: simplePickerView.label.rx.text)
            .disposed(by: disposeBag)
    }
}
