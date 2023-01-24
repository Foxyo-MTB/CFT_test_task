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
        tableView.estimatedRowHeight = 100
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
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
