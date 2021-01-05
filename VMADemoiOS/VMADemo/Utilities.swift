//
//  Utilities.swift
//  VMADemo
//
//  Created by Swetha Sreekanth on 5/1/21.
//  Copyright © 2021 DesiDesign. All rights reserved.
//

import Foundation

class Utilities {
    class func generateRandomBytes(length: Int = 16) -> String? {
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
    
    class func randomData(ofLength length: Int) throws -> Data? {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(bytes)
        }
        // throw an error
        return nil
    }
}
