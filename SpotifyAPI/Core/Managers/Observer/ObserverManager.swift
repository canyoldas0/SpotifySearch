//
//  ObserverManager.swift
//  SpotifyAPI
//
//  Created by Can Yoldaş on 4.09.2022.
//

import Foundation

enum ObservationName: String {
    case signedIn
}


protocol ObservationManagerProtocol {
    
    func subscribe<Observer: AnyObject>(name: ObservationName,
                   observer: Observer,
                   closure: @escaping (Any?) -> Void)
    func notifyObservers(for name: AnyHashable)
    func notifyObservers(for name: AnyHashable, data: Any?)
}

final class ObservationManager: ObservationManagerProtocol {
    private var observations: [AnyHashable: [UUID: (Any?) -> Void]]
    private let queue: DispatchQueue
    
    init() {
        observations = [:]
        queue = DispatchQueue(label: "com.spotifyAPI.observationQueue")
    }
    
    func subscribe<Observer: AnyObject>(
        name: ObservationName,
        observer: Observer, closure: @escaping (Any?) -> Void
    ) {
        let id = UUID()
        
        observations[name, default: [:]][id] = { [weak self, weak observer] data in
            guard observer != nil else {
                let _ = self?.queue.sync {
                    self?.observations[name]?.removeValue(forKey: id)
                }
                return
            }
            closure(data)
        }
    }
    
    func notifyObservers(for name: AnyHashable) {
        notifyObservers(for: name, data: nil)
    }
    
    func notifyObservers(for name: AnyHashable, data: Any?) {
        if let observation = observations[name] {
            observation.forEach { (_, closure) in
                closure(data)
            }
        }
    }
}
