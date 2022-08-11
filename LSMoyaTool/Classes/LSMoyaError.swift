//
//  LSMoyaError.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//

public enum LSMoyaError {
    case timeOut
    case serverDataError
    case dataMapError
    case tokenInvalid
    case refreshTokenError
    case server(String, String, [String: Any])
}

extension LSMoyaError: Error {}

public extension LSMoyaError {
    var status: String {
        switch self {
        case .server(let code, _, _):
            return code
        default:
            return "-1"
        }
    }
    
    var message: String {
        switch self {
        case .timeOut:
            return "网络异常，请检查网络"
        case .serverDataError:
            return "服务器返回数据错误"
        case .tokenInvalid:
            return "会话过期"
        case .dataMapError:
            return "数据解析出错"
        case .refreshTokenError:
            return "登录信息过期,请重新登录"
        case .server(_, let msg, _):
            return msg
        }
    }
    
    var data: [String: Any] {
        switch self {
        case .server(_, _, let data):
            return data
        default:
            return [:]
        }
    }
}

