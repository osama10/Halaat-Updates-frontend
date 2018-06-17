//
//  FirebaseManager.swift
//  Halaat Updates
//
//  Created by inVenD on 16/06/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseManager {
    
    let firStorageRefrence = Storage.storage().reference()
    
    
    func getFileStorageRefrence(storageURL : String)->StorageReference{
        return self.firStorageRefrence.child(storageURL)
    }
    
    func putDataToServer(refrence : StorageReference , fileData : Data , metadata : StorageMetadata? , completion: @escaping stringErrorCallback){
        
        _ = refrence.putData(fileData, metadata: nil) { (metadata, error) in
            guard metadata != nil else {
                completion(nil, error)
                return
            }
            self.getFileUrl(refrence: refrence , completion: completion)
        }
    }
    
    private func getFileUrl(refrence : StorageReference , completion: @escaping stringErrorCallback){
        refrence.downloadURL(completion: { (url, error) in
            completion(url?.absoluteString ?? "none", nil)
        })
    }
}
