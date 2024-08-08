//
//  DetailViewModel.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/8/24.
//

import Foundation
import RxSwift
import UIKit

class DetailViewModel {
    private let disposeBag = DisposeBag()
    
    let pokemonSubject = PublishSubject<Pokemon>()
    let pokemonImageSubject = PublishSubject<UIImage>()
    
    func fetchPokemon(url: String) {
        guard let url = URL(string: url) else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            return
        }
        NetworkManager.shared.fetch(url: url).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] (pokemon: Pokemon) in
            self?.pokemonSubject.onNext(pokemon)
            self?.fetchPokemonImage(url: pokemon.sprites.frontDefault)
        }, onFailure: { error in
            self.pokemonSubject.onError(error)
        }).disposed(by: disposeBag)
    }
    
    func fetchPokemonImage(url: String) {
        guard let url = URL(string: url) else {
            pokemonImageSubject.onError(NetworkError.invalidUrl)
            return
        }
        NetworkManager.shared.fetchImage(url: url).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] (image: UIImage) in
            self?.pokemonImageSubject.onNext(image)
        }, onFailure: { error in
            self.pokemonImageSubject.onError(error)
        }).disposed(by: disposeBag)
    }
    
}
