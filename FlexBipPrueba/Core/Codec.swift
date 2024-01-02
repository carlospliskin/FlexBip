//
//  Codec.swift
//  FlexBipPrueba
//
//  Created by Carlos Paredes León on 16/12/21.
//

import Foundation

public class Codec
{
    public static var AudioSampleRate : Int = 0
    public static var AudioBitRate : Int = 0
    public static var FrameSizeInMs : Int = 0
    public static var DecodedBufferSize : Int = 0
    public static var currentCodec : ICodec? = nil

    public static func GetCodec() -> ICodec
    {
        if (currentCodec == nil)
        {
            //currentCodec = Opus()
        }

        return currentCodec!
    }

    public static func ReleaseCodec() -> Void
    {
        currentCodec?.Close()
        currentCodec = nil
    }

    public static func SetCodecParameters(audioSampleRate : Int, audioBitRate : Int, frameSizeInMs : Int) -> Void
    {
        AudioSampleRate = audioSampleRate
        AudioBitRate = audioBitRate
        FrameSizeInMs = frameSizeInMs
        DecodedBufferSize = audioSampleRate / 1000 * frameSizeInMs
//        SetParameters(audioSampleRate, audioBitRate, frameSizeInMs);
    }

//    private static native void SetParameters(int audioSampleRate, int audioBitRate, int frameSizeInMs);
}

public protocol ICodec
{
    func Encode(pcm : [Int16], offset : Int, size : Int) -> [UInt8]?
    func Decode(encoded : [UInt8], size : Int) -> [Int16]?
    func ResetEncoder() -> Void
    func ResetDecoder() -> Void
    func Close() -> Void
}

//esto es una prueba
