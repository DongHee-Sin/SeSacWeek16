//
//  SimplePickerView.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/26.
//

import UIKit
import SnapKit


final class SimplePickerView: BaseView {
    
    // MARK: - Propertys
    private lazy var pickerStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 20
        view.backgroundColor = .white
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        [pickerView1, pickerView2, pickerView3, label].forEach {
            view.addArrangedSubview($0)
        }
        return view
    }()
    
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    
    let label = UILabel()
    
    
    
    
    // MARK: - Methdos
    override func configureUI() {
        self.addSubview(pickerStackView)
    }
    
    
    override func setConstraint() {
        pickerStackView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
