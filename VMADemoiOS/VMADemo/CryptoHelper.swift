//
//  CryptoHelper.swift
//  Chambers
//
//  Created by Swetha Sreekanth on 10/7/20.
//  Copyright © 2020 Swetha. All rights reserved.
//

import Foundation
import CryptoKit
import CryptoSwift


class CryptoHelper {
    var keyString: Data? = nil
    let salt: Data = "abcdefghijlkmnop".data(using: String.Encoding.utf8)!
    let addData = "3v358YzpzG1rvMPPFb".data(using: String.Encoding.utf8)!
    let ivDat = "GrftUcw6RK4ZHCont95i".data(using:String.Encoding.utf8)!
    init() {
        //keyString = try! CC.KeyDerivation.PBKDF2("q3NbxRlfaQsjuDsy", salt: salt, prf: .sha256, rounds: 100000)
        //print("keyString ::::: \(String(decoding: keyString!, as: UTF8.self))")
        //print("keyString ::::: \(keyString)")
    }
    func encryptData(plainData: Data?) -> Data? {
        
            var encryptData: Data? = nil
            if let key = keyString, let data =  plainData {
                encryptData = try! CC.cryptAuth(.encrypt, blockMode: .gcm, algorithm: .aes, data: data, aData: addData, key: key, iv: ivDat, tagLength: 16)
            }
            return encryptData
        }
    
    func decryptString(data: Data?) -> Data? {
            var decryptString: Data? = nil
            if let key = keyString, let encryptedData = data {
                //
                decryptString = try! CC.cryptAuth(.decrypt, blockMode: .gcm, algorithm: .aes, data: encryptedData, aData: addData, key: key, iv: ivDat, tagLength: 16)
            }
            return decryptString
    }
        
}
