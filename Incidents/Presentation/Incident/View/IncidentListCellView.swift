//
//  IncidentListCell.swift
//  Incidents
//
//  Created by bindu.ojha on 13/10/22.
//

import Foundation
import UIKit

class IncidentListCellView: UITableViewCell{
    
    
    var cellViewModel: IncidentCellModel?{
        didSet{
            self.title.text = cellViewModel?.title
            self.lastUpdatedDate.text =  cellViewModel?.lastUpdateFormatted
            self.badge.text = cellViewModel?.status
            self.badge.backgroundColor = getColor(status: cellViewModel?.status)
        }
    }
    
    
    var imageData: Data?{
        didSet{
            if let imageData = imageData{
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    private lazy var icon: UIView = {
        let view = UIView()
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.shared.iconImageWidth/4),
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.shared.iconImageWidth/4),
            image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constant.shared.iconImageWidth/4),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.shared.iconImageWidth/4)
        ])
        return view
    }()
    
    
    private lazy var lastUpdatedDate: UILabel = {
        let lastUpdatedDate = UILabel()
        lastUpdatedDate.textAlignment = .left
        lastUpdatedDate.numberOfLines = 1
        lastUpdatedDate.font = UIFont.systemFont(ofSize: 12)
        lastUpdatedDate.sizeToFit()
        lastUpdatedDate.textColor = .label
        return lastUpdatedDate
    }()
    
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 1
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.sizeToFit()
        title.textColor = .label
        return title
    }()
    
    
    private lazy var badge: UILabel = {
        let label = PaddingLabel(top: 5, bottom: 5, left: 5, right: 5)
        label.font = .boldSystemFont(ofSize: 12)
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.textAlignment = .left
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    
    private lazy var rightChildStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lastUpdatedDate, title, badge])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        setupView()
    }
    
    
    func setupView(){
        contentView.addSubview(icon)
        contentView.addSubview(rightChildStackView)
        //setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    
    func setupConstraints(){
        setupIconConstraint()
        setupStackViewConstraints()
    }
    
    
    func setupStackViewConstraints(){
        rightChildStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightChildStackView.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 0),
            rightChildStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            rightChildStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            rightChildStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)
        ])
    }
    

    func setupIconConstraint(){
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            icon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            icon.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0),
            icon.widthAnchor.constraint(equalToConstant: Constant.shared.iconImageWidth),

        ])
    }
    
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension IncidentListCellView{
    
    func getColor(status: String?)->UIColor{
        switch(status){
        case "On Scene": return .systemBlue
        case "Under control" : return .systemGreen
        case "Out of control" : return .systemRed
        case "Pending" : return .systemOrange
        default: return .systemFill
        }
    }
}
