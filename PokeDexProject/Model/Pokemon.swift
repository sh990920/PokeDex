//
//  Pokemon.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import Foundation

struct PokemonList: Codable {
    let results: [PokemonUrl]
}

struct PokemonUrl: Codable {
    let url: String
}

struct Pokemon: Codable {
    let id: Int
    let name: String
    let types: [PokemonType]
    let height: Int
    let weight: Int
    let sprites: Sprite
}

struct PokemonType: Codable {
    let slot: Int
    let type: TypeName
}

struct TypeName: Codable {
    let name: String
}

struct Sprite: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
