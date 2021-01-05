//
//  RSAKeyGenerator.swift
//  VMADemo
//
//  Created by Swetha Sreekanth on 24/12/20.
//  Copyright © 2020 DesiDesign. All rights reserved.
//

import Foundation
import SwiftyCrypto
import Security

class RSAKeyGenerator {
    
    var privateKey: RSAKey!
    var publicKey: RSAKey!
    public static let shared = RSAKeyGenerator()
    
    init() {
        generatekeys()
    }
    
    private func generatekeys() {
        guard let publicKeypath = Bundle.main.path(forResource: "vmapublic", ofType: "pem"),
            let privateKeypath = Bundle.main.path(forResource: "vmaprivate", ofType: "pem") else {
            print("RSAKeyGenerator bundle identifier failed")
            return
        }
        let publicKeyString = try? String(contentsOf: URL(fileURLWithPath: publicKeypath), encoding: .utf8)
        let privateKeyString = try? String(contentsOf: URL(fileURLWithPath: privateKeypath), encoding: .utf8)
        privateKey = try! RSAKey.init(base64String: privateKeyString!, keyType: .PRIVATE)
        publicKey = try! RSAKey.init(base64String: publicKeyString!, keyType: .PUBLIC)
    }
    
    func getPublicKey() -> SecKey? {
        if let data = publicKey.key as? Data {
            print("getPublicKey Key: \((data.base64EncodedString()))")
        }
        return publicKey.key
    }
    func getPrivateKey() -> SecKey? {
        if let data = privateKey.key as? Data {
            print("getPrivateKey Key: \((data.base64EncodedString()))")
        }
        
        return privateKey.key
    }
    
}
