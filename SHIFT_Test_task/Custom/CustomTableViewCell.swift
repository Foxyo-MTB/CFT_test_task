//
//  CustomTableViewCell.swift
//  SHIFT_Test_task
//
//  Created by Vladimir Beliakov on 21.01.2023.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    private let mainTableViewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 70 / 2
        imageView.image = UIImage(named: "defaultPhoto")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let mainButton: UIButton = {
       let button = UIButton()
        button.layer.cornerRadius = 70 / 2
        return button
    }()
    
    var indexPath: IndexPath?
    var action: ((IndexPath?)->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func configure() {
        
        mainButton.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        
        contentView.addSubview(mainButton)
        mainButton.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.height.width.equalTo(70)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }

        contentView.addSubview(mainTableViewLabel)
        mainTableViewLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(70)
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(mainImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-10)
        }

    }
    
    func mainTableViewLabelProvidesToVC() -> UILabel {
        mainTableViewLabel
    }
    
    func mainImageViewProvidesToVC() -> UIImageView {
        mainImageView
    }
    
    func mainButtonProvidesToVC() -> UIButton {
        mainButton
    }
    
    @objc private func selectButton() {
        action!(indexPath)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
