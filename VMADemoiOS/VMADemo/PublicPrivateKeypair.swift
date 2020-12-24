//
//  PublicPrivateKeypair.swift
//  VMADemo
//
//  Created by Swetha Sreekanth on 23/12/20.
//  Copyright © 2020 DesiDesign. All rights reserved.
//

import Foundation


class PublicPrivateKeypair {
    
    var publicKey : SecKey?
    var privateKey : SecKey?
    
    func generateRSAPublicKey() {
        let publicKeyAttr: [NSObject: NSObject] = [
                    kSecAttrIsPermanent:true as NSObject,
                    kSecAttrApplicationTag:"org.citi.vma.demo.public".data(using: String.Encoding.utf8)! as NSObject,
                    kSecClass: kSecClassKey, // added this value
                    kSecReturnData: kCFBooleanTrue] // added this value
        let privateKeyAttr: [NSObject: NSObject] = [
                    kSecAttrIsPermanent:true as NSObject,
                    kSecAttrApplicationTag:"org.citi.vma.demo.private".data(using: String.Encoding.utf8)! as NSObject,
                    kSecClass: kSecClassKey, // added this value
                    kSecReturnData: kCFBooleanTrue] // added this value

        var keyPairAttr = [NSObject: NSObject]()
        keyPairAttr[kSecAttrKeyType] = kSecAttrKeyTypeRSA
        keyPairAttr[kSecAttrKeySizeInBits] = 2048 as NSObject
        keyPairAttr[kSecPublicKeyAttrs] = publicKeyAttr as NSObject
        keyPairAttr[kSecPrivateKeyAttrs] = privateKeyAttr as NSObject

       

        let statusCode = SecKeyGeneratePair(keyPairAttr as CFDictionary, &publicKey, &privateKey)

        if statusCode == noErr && publicKey != nil && privateKey != nil {
            print("Key pair generated OK")
            var resultPublicKey: AnyObject?
            var resultPrivateKey: AnyObject?
            let statusPublicKey = SecItemCopyMatching(publicKeyAttr as CFDictionary, &resultPublicKey)
            let statusPrivateKey = SecItemCopyMatching(privateKeyAttr as CFDictionary, &resultPrivateKey)

            if statusPublicKey == noErr {
                if let publicKey = resultPublicKey as? Data {
                 
                    print("Public Key: \((publicKey.base64EncodedString()))")
                      let keyType = kSecAttrKeyTypeRSA
                      let keySize = 2048
                      let exportImportManager = CryptoExportImportManager()
                      if let exportableDERKey = exportImportManager.exportPublicKeyToDER(publicKey, keyType: keyType as String, keySize: keySize) {
                        print("Public Key: der :::: \(exportableDERKey.base64EncodedString())")
                      }
                }
            }

            if statusPrivateKey == noErr {
                if let privateKey = resultPrivateKey as? Data {
                    print("Private Key: \((privateKey.base64EncodedString()))")
                    let keyType = kSecAttrKeyTypeRSA
                    let keySize = 2048
                    let exportImportManager = CryptoExportImportManager()
                    if let exportableDERKey = exportImportManager.exportPublicKeyToDER(privateKey, keyType: keyType as String, keySize: keySize) {
                      print("Private Key: der :::: \(exportableDERKey.base64EncodedString())")
                    }
                }
            }
        } else {
            print("Error generating key pair: \(String(describing: statusCode))")
        }
    }
    
    func getPrivateKey() -> SecKey? {
        return privateKey
    }
    
    func getPublicKey() -> SecKey? {
        return publicKey
    }
}
