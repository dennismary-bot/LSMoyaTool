//
//  LSMoyaError.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//

public enum LSMoyaError {
    case timeOut
    case serverDataError
    case dataMapError(String)
    case server(String, String)
    case tokenInvalid
    case refreshTokenError
}

extension LSMoyaError: Error {}

public extension LSMoyaError {
    var errorMessage: String {
        switch self {
        case .timeOut:
            return "网络异常，请检查网络"
        case .serverDataError:
            return "服务器返回数据错误"
        case .server(_, let msg):
            return msg
        case .tokenInvalid:
            return "会话过期"
        case .dataMapError:
            return "数据解析出错"
        case .refreshTokenError:
            return "登录信息过期,请重新登录"
        }
    }
    
    var errorStatus: String {
        switch self {
        case .server(let code, _):
            return code
        default:
            return "-1"
        }
    }
}

