//
//  FirebaseRealtimeDBService.swift
//  Map
//
//  Created by Evhenii Shovkovyi on 08.07.2024.
//

import Foundation
import FirebaseDatabase
import FirebaseDatabaseSwift

class FirebaseRealtimeDBService: ObservableObject {

    private let ref = Database.database().reference()

    func addToFavorites(for userId: String, place: String) {
        ref.child(userId).child("likedPlaces")
            .observeSingleEvent(of: .value) { snapshot in
                if var array = snapshot.value as? [String] {
                    array.append(place)
                    self.ref.child(userId).child("likedPlaces").setValue(array)
                } else {
                    self.ref.child(userId).child("likedPlaces").setValue([place])
                }
            }
    }

    func removeFromFavorites(for userId: String, place: String) {
        ref.child(userId).child("likedPlaces")
            .observeSingleEvent(of: .value) { snapshot in
                if var array = snapshot.value as? [String] {
                    array = array.filter({ $0 != place })
                    self.ref.child(userId).child("likedPlaces").setValue(array)
                }
            }
    }

    func readFavorites(for userId: String, _ completion: @escaping ([String]) -> Void) {
        ref.child(userId).child("likedPlaces")
            .observeSingleEvent(of: .value) { snapshot in
                if let array = snapshot.value as? [String] {
                    completion(array)
                } else {
                    completion([])
                }
            }
    }

}
