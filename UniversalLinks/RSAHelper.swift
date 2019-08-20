////
////  RSAHelper.swift
////  Cirrus
////
////  Created by Kunal Chavan on 08/07/19.
////  Copyright © 2019 cirrus. All rights reserved.
////
//
//import Foundation
//
//struct RSA {
//    static let padding = SecPadding.PKCS1
//
//    static func encrypt(string: String, publicKey: String, keySize: Int) -> String? {
//
//        let keyString = publicKey.removePEMHeadersAndFooters()
//        guard let secKey = getSecurePublicKey(key: keyString, keySize: keySize) else {
//            return nil
//        }
//
//        var keySize = SecKeyGetBlockSize(secKey)
//        var keyBuffer = [UInt8](repeating: 0, count: keySize)
//
//        let maxChunkLength = keySize - 11
//        let dataBuffer = [UInt8](string.utf8)
//        let dataLength = dataBuffer.count
//
//        var iterations = dataLength/maxChunkLength
//        let remainingIterations = dataLength % maxChunkLength
//
//        if remainingIterations > 0 {
//            iterations += 1
//        }
//
//        var encryptedString = ""
//
//        var startIndex = 0
//        var endIndex = startIndex
//
//        for _ in 1...iterations {
//
//            endIndex = (endIndex + maxChunkLength) > dataLength ? endIndex + (dataLength - endIndex) : endIndex + maxChunkLength
//            let byteSlice = dataBuffer[startIndex..<endIndex]
//
//            let byteArray = Array(byteSlice)
//
//            guard SecKeyEncrypt(secKey, padding, byteArray, byteArray.count, &keyBuffer, &keySize) == errSecSuccess else {
//                return nil
//            }
//
//            encryptedString += Data(bytes: keyBuffer.reversed(), count: keySize).base64EncodedString()
//
//            startIndex += maxChunkLength
//        }
//        return encryptedString
//    }
//
//    static func decrypt(message: String, privateKey: String, keySizeInBits: Int) -> String? {
//        let keyString = privateKey.removePEMHeadersAndFootersFromPrivateKey()
//        guard let secKey = getSecurePrivateKey(key: keyString, keySize: keySizeInBits) else {
////            Logger.log(items: "Key not found")
//            return nil
//        }
//        let keySizeInBytes = keySizeInBits / 8
//        let base64BlockSize = (keySizeInBytes % 3 != 0) ? ((keySizeInBytes / 3) * 4) + 4 : (keySizeInBytes / 3) * 4
//        let dataLength = message.count
//        let iterations = dataLength / base64BlockSize
//
//        var buffer = ""
//
//        var i = 0
//        while i < iterations {
//            let endIndex = base64BlockSize * (i+1)
//
//            let substring = message.getSubstring(from: base64BlockSize*i, endIndex: endIndex-1)
//
//            guard let encryptedData = Data(base64Encoded: substring) else {
//                return nil
//            }
//            //Reverse the encrypted byte array
//            var reversedBytes = [UInt8](encryptedData)
//            reversedBytes = reversedBytes.reversed()
//            let dataToDecrypt = Data(bytes: reversedBytes)
//            guard let decryptedData = decryptWithRSAKey(dataToDecrypt, rsaKeyRef: secKey, padding: .PKCS1) else {
//                return nil
//            }
//
//            guard let chunkMessage = String(data: decryptedData, encoding: .utf8) else {
//                return nil
//            }
//
//            buffer += chunkMessage.replacingOccurrences(of: "\0", with: "")
//
//            i += 1
//        }
//
//        return buffer
//    }
//
//    static func decryptWithRSAKey(_ encryptedData: Data, rsaKeyRef: SecKey, padding: SecPadding) -> Data? {
//        let encryptedDataCount = encryptedData.count
//
//        var encryptedDataAsArray = [UInt8](repeating: 0, count: encryptedDataCount)
//        let encryptedDataAsArrayCount = encryptedDataCount
//        (encryptedData as NSData).getBytes(&encryptedDataAsArray, length: encryptedDataCount)
//
//        var decryptedDataBytesBuffer = [UInt8](repeating: 0, count: encryptedDataAsArrayCount)
//        var decryptedDataAsArrayCount = encryptedDataCount
//
//        let status = SecKeyDecrypt(rsaKeyRef, padding, encryptedDataAsArray, encryptedDataAsArrayCount, &decryptedDataBytesBuffer, &decryptedDataAsArrayCount)
//
//        guard status == noErr else {
//            return nil
//        }
//
//        let decryptedData = Data(bytes: UnsafePointer<UInt8>(decryptedDataBytesBuffer), count: decryptedDataAsArrayCount)
//        return decryptedData
//    }
//
//    static func getSecurePublicKey(key: String, keySize: Int) -> SecKey? {
//        guard let keyData = Data(base64Encoded: key) else {
//            return nil
//        }
//
//        var keyAttributes: CFDictionary {
//            return [kSecAttrKeyType: kSecAttrKeyTypeRSA,
//                    kSecAttrKeyClass: kSecAttrKeyClassPublic,
//                    kSecAttrKeySizeInBits: keySize,
//                    kSecReturnPersistentRef: kCFBooleanTrue] as CFDictionary
//        }
//
//        var error: Unmanaged<CFError>?
//
//        guard let secKey = SecKeyCreateWithData(keyData as CFData, keyAttributes, &error) else {
//            print(error.debugDescription)
//            return nil
//        }
//        return secKey
//    }
//
//    static func getSecurePrivateKey(key: String, keySize: Int) -> SecKey? {
//        guard var keyData = Data(base64Encoded: key, options: .ignoreUnknownCharacters) else {
//            return nil
//        }
//        do {
//
//            guard let strippedData = try keyData.stripKeyHeader() else {
////                Logger.log(items: "Failed to strip header from key data")
//                return nil
//            }
//
//            keyData = strippedData
//
//            let keyDict: [CFString: Any] = [
//                kSecAttrKeyType: kSecAttrKeyTypeRSA,
//                kSecAttrKeyClass: kSecAttrKeyClassPrivate,
//                kSecAttrKeySizeInBits: NSNumber(value: keySize),
//                kSecReturnPersistentRef: true
//            ]
//
//            var error: Unmanaged<CFError>?
//            guard let key = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error) else {
//                print(error.debugDescription)
//                return nil
//            }
//            return key
//        } catch {
////            Logger.log(error: error)
//            return nil
//        }
//    }
//
//}
//
//extension String {
//    func getSubstring(from startIndex: Int, endIndex: Int) -> String {
//        return substring(startIndex..<(endIndex+1))
//    }
//    
//    func substring(_ r: Range<Int>) -> String {
//        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
//        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
//        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
//        return String(self[indexRange])
//    }
//}
