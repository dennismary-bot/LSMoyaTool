//
//  LSPluginType.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//


import Moya

public class LSMoyaLogger:NSObject, PluginType {
    public override init() {}

    /// Called immediately before a request is sent over the network (or stubbed).
    public func willSend(_ request: RequestType, target: TargetType) {
        if LSMoyaConfiguration.shared.lsMoyaConfigur?.openLogger?() ?? false {
            print("LSMoyaLogger requestUrl: \(request.request?.url?.absoluteString ?? String())")
        }
    }
 
    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if  LSMoyaConfiguration.shared.lsMoyaConfigur?.openLogger?() ?? false {
            switch result {
            case .success(let response):
                if let json = try? response.mapJSON(),
                   let dict = json as? [String: Any] {
                    print("LSMoyaLogger Response:")
                    print(dict)
                }
                
            case .failure(let error):
                print("LSMoyaLogger error: \(error.localizedDescription)")
            }
        }
        
        
    }

}

