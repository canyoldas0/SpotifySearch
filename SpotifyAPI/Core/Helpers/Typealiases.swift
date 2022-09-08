//
//  Typealiases.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 2.09.2022.
//

typealias GenericHandler<T> = (T) -> Void
typealias ResponseHandler<T> = (Result<T,Error>) -> Void
typealias VoidHandler = () -> Void
