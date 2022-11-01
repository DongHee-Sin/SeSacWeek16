//
//  ValidationViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa


class SimpleValidationViewController: UIViewController {
    
    // MARK: - Propertys
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SimpleValidationViewModel()
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        //observableVSSubject()
    }
    
    
    
    
    // MARK: - Bind
    // Stream == Sequence (같은 의미, 흐름)
    private func bind() {
        
        // MARK: - Input/Output (개선)
        let input = SimpleValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
    
        output.validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.validation
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
        output.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
        
        
        
        
        // MARK: - Input/Output (Before)
        // Output
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        

        // Input
        let validation = nameTextField.rx.text.orEmpty
            .map { $0.count >= 8 }
            .share()  // 10.25 강의자료에 설명이 되어있음
                      // Subject, Relay는 share가 적용되어 있다. (실행이 공유된다.)

        
        validation    // bind(to:)에게 전달되는 매개변수가 n개 있더라도 Observer가 2개라고 볼 수는 없다. (노션)
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)


        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
        // Input
        stepButton.rx.tap
            .bind { _ in
                print("SHOW ALERT")
            }
            .disposed(by: disposeBag)
    }
    
    
    
    // MARK: - Observable VS Subject
    private func observableVSSubject() {
        
        // Observable
        let observableInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        observableInt.subscribe { value in    // Observer 1
            print("observableInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        observableInt.subscribe { value in    // Observer 2
            print("observableInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        observableInt.subscribe { value in    // Observer 3
            print("observableInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        
        // Subject
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in    // Observer 1
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in    // Observer 2
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in    // Observer 3
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        
        // Driver
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }                 // 여기까진 Observable (Stream이 공유되지 않음)
            .asDriver(onErrorJustReturn: "")   // Driver로 변환
            
        testA
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            .disposed(by: disposeBag)
    }
}
