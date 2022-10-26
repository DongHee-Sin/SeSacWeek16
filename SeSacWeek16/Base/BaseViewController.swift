//
//  BaseViewController.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import RxSwift


class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    

    func configure() {}
}
