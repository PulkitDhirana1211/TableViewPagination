//
//  CustomTableViewCell.swift
//  TableViewPagination
//
//  Created by Pulkit Dhirana on 24/11/23.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {

    static let identifier = "CustomTableViewCell"
    
    private let cellImageView: UIImageView = {
       let image = UIImageView()
       image.layer.masksToBounds = true
       image.translatesAutoresizingMaskIntoConstraints = false
       return image
    }()
    
    private let label: UILabel = {
       let label = UILabel()
       label.numberOfLines = 0
       label.translatesAutoresizingMaskIntoConstraints = false
       label.adjustsFontSizeToFitWidth = true
       return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellImageView)
        contentView.addSubview(label)
        applyConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        
        let cellImageConstraints = [
            cellImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cellImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            cellImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            cellImageView.widthAnchor.constraint(equalToConstant: 140)
        ]
        
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ]
        
        NSLayoutConstraint.activate(cellImageConstraints)
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    public func configure(with model: PostModel) {
        cellImageView.sd_setImage(with: URL(string: model.thumbnailURL ?? ""), completed: nil)
        label.text = model.title ?? ""
    }
    
    
    
}
