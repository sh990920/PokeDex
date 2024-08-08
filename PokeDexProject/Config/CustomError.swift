//
//  CustomError.swift
//  PokeDexProject
//
//  Created by 박승환 on 8/7/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
    case imageConversionFail
}
