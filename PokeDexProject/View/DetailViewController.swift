//
//  DetailViewController.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/8/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class DetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    let detailViewModel = DetailViewModel()
    let detailView = DetailView()
    var image = UIImage() {
        didSet {
            configurePokemonImage(image: image)
        }
    }
    
    var pokemon: Pokemon? = nil {
        didSet {
            if let pokemon = pokemon {
                configurePokemon(pokemon: pokemon)
            }
        }
    }
    
    var url: String? {
        didSet {
            detailViewModel.fetchPokemon(url: url!)
            dataSetting()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainRed
        configureUI()
    }
    
    func dataSetting() {
        detailViewModel.pokemonSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] pokemon in
            self?.pokemon = pokemon
        }).disposed(by: disposeBag)
        detailViewModel.pokemonImageSubject.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] image in
            self?.image = image
        }).disposed(by: disposeBag)
    }
    
    func configureUI() {
        view.addSubview(detailView)
        view.backgroundColor = .mainRed
        detailView.layer.cornerRadius = 20
        detailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalToSuperview().inset(40)
            $0.height.equalTo(400)
        }
    }
    
    func configurePokemon(pokemon: Pokemon) {
        let nameText = PokemonTranslator.getKoreanName(for: pokemon.name)
        detailView.pokemonIdAndName.text = "No.\(pokemon.id)  \(nameText)"
        var typeText = "타입 : "
        for (idx, type) in pokemon.types.enumerated() {
            guard let typeName = convertToKoreanTypeName(from: type.type) else { return }
            if idx == pokemon.types.count - 1 {
                typeText += typeName
            } else {
                typeText += "\(typeName), "
            }
        }
        detailView.pokemonType.text = typeText
        detailView.pokemonHeight.text = "키 : \(Double(pokemon.height) / 10)m"
        detailView.pokemonWeight.text = "몸무게 : \(Double(pokemon.weight) / 10)kg"
    }
    
    func configurePokemonImage(image: UIImage) {
        detailView.pokemonImage.image = image
    }
    
}
