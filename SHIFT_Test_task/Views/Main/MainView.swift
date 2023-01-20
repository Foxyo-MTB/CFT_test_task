//
//  MainView.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 20.01.2023.
//

import UIKit
import SnapKit

class MainView: UIView {
    
    private let mainTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 120
        return tableView
    }()
    
    override func layoutSubviews() {
        self.backgroundColor = .white
    }
    
    func mainTableViewProvidesToVC() -> UITableView {
        mainTableView
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    
    private func setupView() {
        
        self.addSubview(mainTableView)
        mainTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
