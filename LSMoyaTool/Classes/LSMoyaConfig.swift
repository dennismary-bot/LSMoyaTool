//
//  LSMoyaConfig.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//

import Foundation

public class LSMoyaConfiguration {
    public static let shared = LSMoyaConfiguration()
    
    public var lsMoyaConfigur: LSMoyaConfigurationProtocol?
    
    public func startWith(_ moyaConfigur: LSMoyaConfigurationProtocol) {
        lsMoyaConfigur = moyaConfigur
    }
    
}

@objc public protocol LSMoyaConfigurationProtocol {
    /// Determine the rest request is successful or unsuccessful
    @objc optional func baseModelIsSucceed(_ data: Data) -> Bool

    /// The network returned a response status code
    @objc optional func baseModelStatusCode(_ data: Data) -> String

    /// The network returned a response message
    @objc optional func baseModelMessage(_ data: Data) -> String
    
    /// timeoutIntervalForRequest
    /// default 20.0
    @objc optional func timeoutIntervalForRequest() -> TimeInterval
    
    /// timeoutIntervalForResource
    /// /// default 20.0
    @objc optional func timeoutIntervalForResource() -> TimeInterval
    
    /// rest requests host
    func host() -> String
    
    /// open request logger
    /// default false
    @objc optional func openLogger() -> Bool
    
    /// The network returned a response status code
    /// default 200
    @objc optional func networkResponseCode() -> Int
    
    
}
