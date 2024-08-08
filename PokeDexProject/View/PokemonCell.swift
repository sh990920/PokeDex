//
//  CollectionViewCell.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import Foundation
import UIKit
import SnapKit

class PokemonCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .cellBackground
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
}
