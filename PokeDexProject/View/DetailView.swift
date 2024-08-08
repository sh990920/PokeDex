//
//  DetailView.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/8/24.
//

import Foundation
import UIKit
import SnapKit

class DetailView: UIView {
    let pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    let pokemonIdAndName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    let pokemonType: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    let pokemonHeight: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    let pokemonWeight: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.backgroundColor = .darkRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
                
        [pokemonImage, pokemonIdAndName, pokemonType, pokemonHeight, pokemonWeight].forEach { addSubview($0) }
        
        pokemonImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }

        pokemonIdAndName.snp.makeConstraints {
            $0.top.equalTo(pokemonImage.snp.bottom)
            $0.height.equalTo(50)
            $0.centerX.equalToSuperview()
        }
        
        pokemonType.snp.makeConstraints {
            $0.top.equalTo(pokemonIdAndName.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        pokemonHeight.snp.makeConstraints {
            $0.top.equalTo(pokemonType.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        pokemonWeight.snp.makeConstraints {
            $0.top.equalTo(pokemonHeight.snp.bottom).offset(10)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
    }
    
}
