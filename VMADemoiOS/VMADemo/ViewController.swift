//
//  ViewController.swift
//  VMADemo
//
//  Created by Swetha Sreekanth on 14/12/20.
//  Copyright © 2020 DesiDesign. All rights reserved.
//

import UIKit
import CryptoSwift
import JOSESwift

class ViewController: UIViewController {
    var key: String? =  "somerandometextusedaskeyforencrpytiontotest" //"1xTqTvDzmtQhfVLwlaARVEEFO+J4Idifg19qa7GGfh0="
    var iv: String? = "ivpairstobegeneratedtotest"
    let plaintext = "Testing my encryption mechanism".bytes
    let plainData = "Testing my encryption mechanism".data(using: String.Encoding.utf8)!
    var encrypted :[UInt8] = []
    var keyData: Data? = nil
    var ivData: Data? = nil
    let keys = PublicPrivateKeypair()
    var jwtString: String?
    var tag: Array<UInt8>?
    let addData = try! Utilities.randomData(ofLength: 32)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //keys.generateRSAPublicKey()
        key = Utilities.generateRandomBytes(length: 32)
        iv = Utilities.generateRandomBytes(length: 16)
        keyData =  try! Utilities.randomData(ofLength: 32)
        ivData = try! Utilities.randomData(ofLength: 16)
        //encryptKey()
        //decryptKey()
        let encrypted = encryptData(plainData: plainData)
        let decrypt = decryptString(data: encrypted)
        let message = "Summer ⛱, Sun ☀️, Cactus 🌵".data(using: .utf8)!
        let header = JWEHeader(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM)
        let payload = Payload(message)
        let publickey =  RSAKeyGenerator.shared.getPublicKey()//keys.getPublicKey()
        let privateKey = RSAKeyGenerator.shared.getPrivateKey()//keys.getPrivateKey()
        //print("privateKey ::::: \(privateKey)")
        //print("publickey :::: \(publickey)")
//       let encrypter = Encrypter(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM, encryptionKey: publickey!)!
//        print("encrypter :::: \(encrypter)")
//        if let jwe = try? JWE(header: header, payload: payload, encrypter: encrypter) {
//            jwtString = jwe.compactSerializedString
//            print("jwtString :::::: \(jwtString!)")
//        }
//        let jwtJavaString = "eyJhbGciOiJSU0EtT0FFUC0yNTYiLCJlbmMiOiJBMjU2R0NNIn0.zCXaIZRdZhwiCB7TsTvAQPGY2QXZ9AkeB4dyAOT70KqrgpiSra92D56EQRD9yWJ4Q2_GqBOAKjkEewMouJiOjEGnMoN1f3lICTlqNhmxuQNDU4U5LXlmBDLa5OudhiBhZ4vxgnaDtZ83r9sRAMGCOvzY5o2Q5JIuJ-1Cs_IqhoVpxx9VLiig1NGP4eJW764B8DeXfDQpfl52X60cA2lkV9HMPfnTfWZaKKfes0dSPqcqlJdJmiEXGP38DYw7fnkRWS_A5G-R0rwzadjJGuedbAX_cG-9OwhUZUDJ0ClMZTlguD_iClFBxdxUhpDb9mpyAnaLP1djlso0w6IC5XdYIQ.US1juylWtg0tHEY3.Tbavvfg-TUBDaZfg.pjUhQ0JgzQLG-DGtgUB6wA"
//        do {
//            let jwe = try JWE(compactSerialization: jwtJavaString)
//            print("jwe :::: \(jwe)")
//            let decrypter = Decrypter(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM, decryptionKey: privateKey!)!
//            print("decrypter :::: \(decrypter)")
//            let payload = try jwe.decrypt(using: decrypter)
//            let message = String(data: payload.data(), encoding: .utf8)!
//
//            print(message) // Summer ⛱, Sun ☀️, Cactus 🌵
//        }catch {
//            print("Decryption error ::::: \(error.localizedDescription)")
//        }
    }
    
    
    
    func encryptKey() {
        if let iv = ivData?.hexEncodedString(), let key = keyData?.hexEncodedString() {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            let gcm = GCM(iv: [UInt8](hex: iv), mode: .detached)
            let aes = try! AES(key: [UInt8](hex: key), blockMode: gcm, padding: .noPadding)
            encrypted = try! aes.encrypt(plaintext)
            tag = gcm.authenticationTag!
            
        
        }
          
        
    }
    
    func decryptKey() {
        do {
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            if let iv = ivData?.hexEncodedString(), let key = keyData?.hexEncodedString() {
                let gcm = GCM(iv:  [UInt8](hex: iv),authenticationTag: tag!, mode: .detached)
                let aes = try AES(key: [UInt8](hex: key), blockMode: gcm, padding: .noPadding)
                let plaintext =  try aes.decrypt(encrypted)
                print("plaintext ::::::: \(plaintext)")
                if let stringtext = String(bytes: plaintext, encoding: .utf8) {
                    print("stringtext ::::::: \(stringtext)")
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
   
    
    func encryptData(plainData: Data?) -> Data? {
            var encryptData: Data? = nil
            if let key = keyData, let data =  plainData, let iv = ivData, let adDData = addData  {
                encryptData = try! CC.cryptAuth(.encrypt, blockMode: .gcm, algorithm: .aes, data: data, aData: adDData, key: key, iv: iv, tagLength: 16)
            }
            print("encryptData :::: \(String(decoding: encryptData!, as: UTF8.self))")
            return encryptData
        }
    
    func decryptString(data: Data?) -> Data? {
            var decryptString: Data? = nil
            if let key = keyData, let encryptedData = data,let iv = ivData, let adDData = addData {
                //
                decryptString = try! CC.cryptAuth(.decrypt, blockMode: .gcm, algorithm: .aes, data: encryptedData, aData: adDData, key: key, iv: iv, tagLength: 16)
            }
            print("decryptString :::: \(String(decoding: decryptString!, as: UTF8.self))")
            return decryptString
    }

}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

