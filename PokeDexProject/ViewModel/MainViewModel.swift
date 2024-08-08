//
//  MainViewModel.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import Foundation
import RxSwift
import UIKit

class MainViewModel {
    private let disposeBag = DisposeBag()
    private let limit = 20
    private var offset = 0
    var isLoading = false
    
    let pokemonSubject = BehaviorSubject(value: [PokemonUrl]())
    let pokemonImageSubject = BehaviorSubject(value: [UIImage]())
    
    init() {
        fetchPokemon()
    }
    
    func fetchPokemon() {
        guard !isLoading else { return }
        isLoading = true
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)") else {
            pokemonSubject.onError(NetworkError.invalidUrl)
            isLoading = false
            return
        }
        NetworkManager.shared.fetch(url: url).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] (pokemonResponse: PokemonList) in
            guard let self = self else { return }
            self.offset += self.limit
            var currentResults = (try? self.pokemonSubject.value()) ?? []
            currentResults.append(contentsOf: pokemonResponse.results)
            self.pokemonSubject.onNext(currentResults)
            self.fetchPokemonImages(pokemonUrls: pokemonResponse.results)
            self.isLoading = false
        }, onFailure: { [weak self] error in
            self?.pokemonSubject.onError(error)
            self?.isLoading = false
        }).disposed(by: disposeBag)
    }
    
    func fetchNextPokemon() {
        fetchPokemon()
    }

    func fetchImage(idList: [Int]) {
        
        let imageFetches = idList.map { id -> Single<UIImage> in
            guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png") else {
                return Single.error(NetworkError.invalidUrl)
            }
            return NetworkManager.shared.fetchImage(url: url)
        }
        Single.zip(imageFetches).observe(on: MainScheduler.instance).subscribe(onSuccess: { [weak self] images in
                guard let self = self else { return }
                do {
                    var currentImages = try self.pokemonImageSubject.value()
                    currentImages.append(contentsOf: images)
                    self.pokemonImageSubject.onNext(currentImages)
                } catch {
                    self.pokemonImageSubject.onError(error)
                }
            }, onFailure: { [weak self] error in
                self?.pokemonImageSubject.onError(error)
            }).disposed(by: disposeBag)
    }


    func fetchPokemonImages(pokemonUrls: [PokemonUrl]) {
        var idList = [Int]()
        for i in pokemonUrls {
            let id = i.url.split(separator: "/")[5]
            guard let num = Int(id) else { return }
            idList.append(num)
        }
        fetchImage(idList: idList)
    }
    
}
