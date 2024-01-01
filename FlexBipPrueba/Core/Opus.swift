//  Opus.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 05/01/22.

import Foundation
import Opus

public class Opus : ICodec
{
    private static let TAG : String = "Opus"
    public var verbose : Bool = false

    private var _encoder : OpaquePointer!
    private var _decoder : OpaquePointer!
    private var encodeBuffer : [opus_int16] = []
    private var decodeBuffer : [opus_int16] = []
    private var encodedBytes : [UInt8] = []
    
    public init()
    {
        encodeBuffer = [opus_int16](repeating: 0, count: Codec.AudioSampleRate / 1000 * Codec.FrameSizeInMs)
        decodeBuffer = [opus_int16](repeating: 0, count: Codec.AudioSampleRate / 1000 * Codec.FrameSizeInMs)
        encodedBytes = [UInt8](repeating: 0, count: 16384)
        
        var result : Int32 = 0
        _encoder = opus_encoder_create(opus_int32(Codec.AudioSampleRate), 1, OPUS_APPLICATION_VOIP, &result)
        if (result != OPUS_OK)
        {
            Logger.e(Opus.TAG, "opus_encoder_init error - \(result)")
            return
        }
        _decoder = opus_decoder_create(opus_int32(Codec.AudioSampleRate), 1, &result)
        if (result != OPUS_OK)
        {
            Logger.e(Opus.TAG, "opus_encoder_init error - \(result)")
            return
        }
        
        
    }
    
    public func Encode(pcm: [Int16], offset: Int, size: Int) -> [UInt8]?
    {
        if (_encoder == nil)
            { return nil }

        var i : Int = 0
        while (i < encodeBuffer.count)
        {
            encodeBuffer[i] = pcm[i]
            i += 1
        }
        
        let result = Int(opus_encode(_encoder, encodeBuffer, Int32(encodeBuffer.count), &encodedBytes, opus_int32(encodedBytes.count)))
        if (result < 0)
        {
            Logger.e(Opus.TAG, "opus_encode error - \(result)")
            return nil
        }
        
        var bytes = [UInt8](repeating: 0, count: result)
        Utils.ArrayCopy(encodedBytes, 0, &bytes, 0, result)
        
        return bytes
    }
    
    public func Decode(encoded: [UInt8], size: Int) -> [Int16]?
    {
        if (_decoder == nil)
            { return nil }

        let result = Int(opus_decode(_decoder, encoded, opus_int32(encoded.count), &decodeBuffer, Int32(decodeBuffer.count), 0))
        if (result != decodeBuffer.count)
        {
            Logger.e(Opus.TAG, "opus_decode error - \(result)")
            return nil
        }
        return decodeBuffer.map { Int16($0) }
    }
    
    public func ResetEncoder() -> Void
    {
        
    }
    
    public func ResetDecoder() -> Void
    {
        
    }
    
    public func Close()
    {
        if (_encoder == nil)
            { return }
        
        opus_encoder_destroy(_encoder)
        _encoder = nil
        
        if (_decoder == nil)
            { return }

        opus_decoder_destroy(_decoder)
        _decoder = nil
        
    }
    
    
}

