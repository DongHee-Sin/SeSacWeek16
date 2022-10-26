//
//  RXTableView.swift
//  SeSacWeek16
//
//  Created by 신동희 on 2022/10/27.
//

import UIKit
import SnapKit


final class RXTableView: BaseView {
    
    let addCellButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Cell 추가하기", for: .normal)
        $0.backgroundColor = .green
    }
    
    let tableView = UITableView().then {
        $0.backgroundColor = .white
    }
    
    
    override func configureUI() {
        [tableView, addCellButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraint() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        addCellButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}
