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
    var encrypted :[UInt8] = []
    var keyData: Data? = nil
    var ivData: Data? = nil
    let keys = PublicPrivateKeypair()
    var jwtString: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        keys.generateRSAPublicKey()
        key = generateRandomBytes(length: 32)
        iv = generateRandomBytes(length: 16)
        keyData =  try! randomData(ofLength: 32)
        ivData = try! randomData(ofLength: 16)
        let message = "Summer ⛱, Sun ☀️, Cactus 🌵".data(using: .utf8)!
        let header = JWEHeader(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM)
        let payload = Payload(message)
        let publickey = keys.getPublicKey()
        let privateKey = keys.getPrivateKey()
        print("privateKey ::::: \(privateKey)")
        print("publickey :::: \(publickey)")
       let encrypter = Encrypter(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM, encryptionKey: publickey!)!
        print("encrypter :::: \(encrypter)")
        if let jwe = try? JWE(header: header, payload: payload, encrypter: encrypter) {
            jwtString = jwe.compactSerializedString
            print("jwtString :::::: \(jwtString)")
        }
        do {
            let jwe = try JWE(compactSerialization: jwtString!)
            print("jwe :::: \(jwe)")
            let decrypter = Decrypter(keyManagementAlgorithm: .RSAOAEP256, contentEncryptionAlgorithm: .AES256GCM, decryptionKey: privateKey!)!
            print("decrypter :::: \(decrypter)")
            let payload = try jwe.decrypt(using: decrypter)
            let message = String(data: payload.data(), encoding: .utf8)!

            print(message) // Summer ⛱, Sun ☀️, Cactus 🌵
        }catch {
            print("Decryption error ::::: \(error.localizedDescription)")
        }
    }
    
    func generateRandomBytes(length: Int = 16) -> String? {
        var keyData = Data(count: length)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, length, $0)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    
    public func randomData(ofLength length: Int) throws -> Data? {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(bytes)
        }
        // throw an error
        return nil
    }
    
    func encryptKey() {
        if let iv = ivData?.hexEncodedString(), let key = keyData?.hexEncodedString() {
            // In combined mode, the authentication tag is directly appended to the encrypted message. This is usually what you want.
            print("iv hex ::::: \([UInt8](hex: iv))")
            print("iv key ::::: \([UInt8](hex: key))")
            let gcm = GCM(iv: [UInt8](hex: iv), mode: .combined)
            let aes = try! AES(key: [UInt8](hex: key), blockMode: gcm, padding: .noPadding)
            encrypted = try! aes.encrypt(plaintext)
            print("encrypted ::::::: \(encrypted)")
            print("encrypted string::::::: \(encrypted.toHexString())")
            let tag = gcm.authenticationTag
            print("tag :::::: \(tag!)")
            print("tag data:::::: \(Data(tag!))")
            print("tag hexEncodedString:::::: \(tag!.toHexString())")
        
        }
          
        
    }
    
    func decryptKey() {
        do {
            // In combined mode, the authentication tag is appended to the encrypted message. This is usually what you want.
            if let iv = ivData?.hexEncodedString(), let key = keyData?.hexEncodedString() {
                let gcm = GCM(iv:  [UInt8](hex: iv), mode: .combined)
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
    
    func createJwt() {
        //let jwtHeader = JWEHeader(keyManagementAlgorithm: KeyManagementAlgorithm, contentEncryptionAlgorithm: ContentEncryptionAlgorithm)
    }

}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

