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
    let pokemonImage = UIImageView()
    let stackView = UIStackView()
    let pokemonId = UILabel()
    let pokemonName = UILabel()
    let pokemonType = UILabel()
    let pokemonHeight = UILabel()
    let pokemonWeight = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        self.backgroundColor = .darkRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
                
        stackView.addArrangedSubview(pokemonId)
        stackView.addArrangedSubview(pokemonName)
        pokemonId.textAlignment = .center
        pokemonName.textAlignment = .center
    }
    
    func configureUI() {
        configureStackView()
        pokemonId.font = .boldSystemFont(ofSize: 25)
        pokemonName.font = .boldSystemFont(ofSize: 25)
        pokemonId.textColor = .white
        pokemonName.textColor = .white
        pokemonType.textColor = .white
        pokemonHeight.textColor = .white
        pokemonWeight.textColor = .white
        
        
        [pokemonImage, stackView, pokemonType, pokemonHeight, pokemonWeight].forEach { addSubview($0) }
        
        pokemonImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.width.equalTo(150)
            $0.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(pokemonImage.snp.bottom)
            $0.height.equalTo(50)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        pokemonType.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        pokemonHeight.snp.makeConstraints {
            $0.top.equalTo(pokemonType.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
        
        pokemonWeight.snp.makeConstraints {
            $0.top.equalTo(pokemonHeight.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.centerX.equalToSuperview()
        }
    }
    
}
