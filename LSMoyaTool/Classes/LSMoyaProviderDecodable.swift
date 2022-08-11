//
//  LSMoyaProviderDecodable.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//

import Foundation

struct LSMoyaProviderDecodable {
    static func decodableObject<T: Decodable>(data: Data,
                                              type: T.Type,
                                              decoder: JSONDecoder = JSONDecoder.init(),
                                              keyPath: String? = "data") throws -> T {

        let json = try JSONSerialization.jsonObject(with: data,
                                                        options: .allowFragments)
        
        guard let keyPath = keyPath, !keyPath.isEmpty else {
            if (!JSONSerialization.isValidJSONObject(json)) {
                throw LSMoyaError.serverDataError
            }
            var nestedData: Data!
            var nestedObj: T!
            do {
                nestedData = try JSONSerialization.data(withJSONObject: json)
                nestedObj = try decoder.decode(T.self, from: nestedData)
                return nestedObj
            } catch {
                throw LSMoyaError.dataMapError
            }
            
        }
        
        let isSucceed = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelIsSucceed?(data) ?? false
        let statusCode = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelStatusCode?(data) ?? "0"
        let message = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelMessage?(data) ?? ""
        
        if isSucceed {
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                if (!JSONSerialization.isValidJSONObject(nestedJson)) {
                    throw LSMoyaError.serverDataError
                }
                do {
                    let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
                    let nestedObj = try decoder.decode(T.self, from: nestedData)
                    return nestedObj
                } catch {
                    throw LSMoyaError.dataMapError
                }
            }
           
            throw LSMoyaError.serverDataError
            
        }
        
        if let dict = json as? [String: Any], let dataDict = dict["data"] as? [String: Any] {
            throw LSMoyaError.server(statusCode, message, dataDict)
        }else {
            throw LSMoyaError.server(statusCode, message, [:])
        }

    }

    static func decodableArrayObject<T: Decodable>(data: Data, type: T.Type, decoder: JSONDecoder = JSONDecoder.init(), keyPath: String? = "data") throws -> [T] {
        
        guard let keyPath = keyPath, !keyPath.isEmpty else {
            // 适用于通用数据类型
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let nestedJsons = (json as AnyObject) as? NSArray {
                var nestedObjs: [T] = []
                for nestedJson in nestedJsons {
                    do {
                        let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
                        let nestedObj = try decoder.decode(T.self, from: nestedData)
                        nestedObjs.append(nestedObj)
                    } catch {
                        throw LSMoyaError.dataMapError
                    }
                }
                return nestedObjs
            } else {
                throw LSMoyaError.serverDataError
            }
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        
        let isSucceed = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelIsSucceed?(data) ?? false
        let statusCode = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelStatusCode?(data) ?? "0"
        let message = LSMoyaConfiguration.shared.lsMoyaConfigur?.baseModelMessage?(data) ?? ""
        
        
        if isSucceed {
            if let nestedJsons = ((json as Any) as AnyObject).value(forKeyPath: keyPath) as? NSArray {
                var nestedObjs: [T] = []
                for nestedJson in nestedJsons {
                    do {
                        let nestedData = try JSONSerialization.data(withJSONObject: nestedJson)
                        let nestedObj = try decoder.decode(T.self, from: nestedData)
                        nestedObjs.append(nestedObj)
                    } catch {
                        throw LSMoyaError.dataMapError
                    }
                }
                return nestedObjs
            }
            
            throw LSMoyaError.serverDataError
            
        }
        
        if let dict = json as? [String: Any], let dataDict = dict["data"] as? [String: Any] {
            throw LSMoyaError.server(statusCode, message, dataDict)
        }else {
            throw LSMoyaError.server(statusCode, message, [:])
        }
        
    }

}

