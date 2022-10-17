//
//  IncidentDetailCellView.swift
//  Incidents
//
//  Created by bindu.ojha on 15/10/22.
//

import Foundation
import UIKit


class IncidentDetailCellView: UITableViewCell{
    
    // Update Cell properties
    var cellViewModel: IncidentDetailModelTable?{
        didSet{
            if let title = cellViewModel?.contentTile, let desc = cellViewModel?.contentDescription{
                let text = title + "\n" + desc
                let attributedText = text.attributedString(titleLength: title.count, colour: [.secondaryLabel, .label], fontSize: [13, 14])
                self.title.attributedText = attributedText
            }
        }
    }
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.textAlignment = .left
        title.numberOfLines = 0
        title.sizeToFit()
        title.textColor = .systemGray
        title.lineBreakMode = .byWordWrapping
        return title
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
        contentView.addSubview(title)
    }
    
    
    func setupConstraints(){
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
}

// Extension to create attributed strings with different colour and font
extension String{
    func attributedString(titleLength: Int, colour: [UIColor],  fontSize: [CGFloat])->NSMutableAttributedString{
        
        let attributedString = NSMutableAttributedString(string: self)
        var range = NSRange(location: 0, length: titleLength)
        
        
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[NSAttributedString.Key.foregroundColor] = colour[0]
        attributes[NSAttributedString.Key.font] =  UIFont.systemFont(ofSize:fontSize[0])
        
        attributedString.addAttributes(attributes, range: range)
        
        range = NSRange(location: titleLength + 1, length: self.count - 1 - titleLength)
        attributes[NSAttributedString.Key.foregroundColor] = colour[1]
        attributes[NSAttributedString.Key.font] =  UIFont.systemFont(ofSize:fontSize[1])
        
        attributedString.addAttributes(attributes, range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
}
