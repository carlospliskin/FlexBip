//
//  AesEncryptor.swift
//  SocketSwiftStoryboard
//
//  Created by Carlos Paredes León on 15/12/21.
//

import Foundation

public class AesEncryptor
{
    var TAIL : Int = 32;
    var keyBytes : [UInt8] = [UInt8](repeating: 0, count: 32);
    var emptyBuffer : Data;
    var encodeBuffer : [UInt8];

    public init(bufferSize : Int) throws
    {
        emptyBuffer = Data(count: bufferSize + TAIL);
        encodeBuffer = [UInt8](repeating: 0, count: bufferSize + TAIL);
    }
    
    public func Encrypt(key : [UInt8], data : [UInt8]) throws -> [UInt8]
    {
        let keyMatch : Bool = KeyMatch(newKey: key);
        if (!keyMatch)
        {
            keyBytes = key;
        }
        
        let iv : [UInt8] = withUnsafeBytes(of: Utils.Random(min: 0, max: UInt32.max), Array.init);
        var ivBytes : [UInt8] = [UInt8](repeating: 0, count: 16);
        
        Utils.ArrayCopy(iv, 0, &ivBytes, 0, 4);
        Utils.ArrayCopy(iv, 0, &ivBytes, 4, 4);
        Utils.ArrayCopy(ivBytes, 0, &ivBytes, 8, 8);

        let cipher : AES256 = try AES256(key: Data(key), iv: Data(ivBytes));
        
        var result : [UInt8] = [UInt8](repeating: 0, count: data.count + 8);
        Utils.ArrayCopy(ivBytes, 0, &result, 0, 4);
        let encripted = try cipher.encrypt(emptyBuffer);
        let encodeBuffer : [UInt8] = Array(encripted);
        
        var i : Int = 0
        while (i < 4)
        {
            result[4 + i] = (ivBytes[i] ^ encodeBuffer[i]);
            i += 1
        }
        i = 0;
        while (i < data.count)
        {
            result[8 + i] = (data[i] ^ encodeBuffer[4 + i]);
            i += 1
        }
        return result;
    }
    
    public func Decrypt(key : [UInt8], data : [UInt8]) throws -> [UInt8]?
    {
        let keyMatch : Bool = KeyMatch(newKey: key);
        if (!keyMatch)
        {
            keyBytes = key;
        }
        
        var ivBytes : [UInt8] = [UInt8](repeating: 0, count: 16);

        Utils.ArrayCopy(data, 0, &ivBytes, 0, 4);
        Utils.ArrayCopy(data, 0, &ivBytes, 4, 4);
        Utils.ArrayCopy(ivBytes, 0, &ivBytes, 8, 8);

        let cipher : AES256 = try AES256(key: Data(key), iv: Data(ivBytes));
        var result : [UInt8] = [UInt8](repeating: 0, count: data.count - 8);
        let encripted = try cipher.encrypt(emptyBuffer);
        let encodeBuffer : [UInt8] = Array(encripted);
        
        var i : Int = 0
        while (i < 4)
        {
            let nextByte : UInt8 = (data[4 + i] ^ encodeBuffer[i]);
            if (nextByte != ivBytes[i])
            {
                return nil;
            }
            i += 1
        }
        i = 0;
        while (i < result.count)
        {
            let nextByte : UInt8 = (data[8 + i] ^ encodeBuffer[4 + i]);
            result[i] = nextByte;
            i += 1
        }
        
        return result;
    }

    private func KeyMatch(newKey : [UInt8] ) -> Bool
    {
        var i : Int = 0
        while (i < newKey.count)
        {
            if (newKey[i] != keyBytes[i])
            {
                return false;
            }
            
            i += 1;
        }

        return true;
    }
}
