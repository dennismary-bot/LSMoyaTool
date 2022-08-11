//
//  LSMoyaProvider.swift
//  LSMoyaTool_test
//
//  Created by YatuNetwork  on 2022/6/29.
//

import Moya
import RxSwift
import Alamofire

public class LSMoyaProvider<Target: TargetType> {
    
    private let provider: MoyaProvider<Target>
    
    public init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = LSMoyaProvider.endpointMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub,
         session: Session = LSMoyaProvider.sessionManager(),
                plugins: [PluginType] = [LSMoyaLogger()],
         trackInflights: Bool = false) {
        
        self.provider = MoyaProvider(endpointClosure: endpointClosure,
                                     stubClosure: stubClosure,
                                     session: session,
                                     plugins: plugins,
                                     trackInflights: trackInflights)
        
    }
    
    public func request(_ target: Target) -> Observable<Moya.Response> {
        return provider.rx
            .request(target)
            .asObservable()
    }
  
}

extension LSMoyaProvider {
    public static func endpointMapping(_ target: Target) -> Endpoint {
         var urlString = URL.init(target: target).absoluteString
         urlString = urlString.replacingOccurrences(of: "%3F", with: "?")
         return Endpoint(
             url: urlString,
             sampleResponseClosure: { .networkResponse(LSMoyaConfiguration.shared.lsMoyaConfigur?.networkResponseCode?() ?? 200, target.sampleData) },
             method: target.method,
             task: target.task,
             httpHeaderFields: target.headers
         )
     }

     public static func sessionManager() -> Session {
         let configuration = URLSessionConfiguration.default
         configuration.timeoutIntervalForRequest = LSMoyaConfiguration.shared.lsMoyaConfigur?.timeoutIntervalForRequest?() ?? 20.0
         configuration.timeoutIntervalForResource = LSMoyaConfiguration.shared.lsMoyaConfigur?.timeoutIntervalForResource?() ?? 20.0

         let evaluators: [String: ServerTrustEvaluating] = [
            LSMoyaConfiguration.shared.lsMoyaConfigur?.host() ?? "": .pinnedCertificates(certificates: Bundle.main.af.certificates, acceptSelfSignedCertificates: false, performDefaultValidation: false, validateHost: true)
         ]

         let sessionDelegate = SessionDelegate()
         
         let session = Session.init(configuration: configuration, delegate: sessionDelegate, serverTrustManager: ServerTrustManager.init(allHostsMustBeEvaluated: false, evaluators: evaluators))
         
         return session
         
     }
}

public extension ObservableType where Element == Response {
    
    func mapToModel<T: Decodable>(_: T.Type, decoder: JSONDecoder = JSONDecoder.init(), keyPath: String? = "data") -> Observable<T> {
        return map({ (response) -> T in
            let object = try LSMoyaProviderDecodable.decodableObject(data: response.data, type: T.self, decoder: decoder, keyPath: keyPath)
            return object
        }).catch { (err) -> Observable<T> in
            return Observable<T>.create({ (observe) -> Disposable in
                observe.onError(moyaFinalError(error: err))
                return Disposables.create()
            })}
    }
    
    func mapToArrayModel<T: Decodable>(_: T.Type, decoder: JSONDecoder = JSONDecoder.init(), keyPath: String? = "data") -> Observable<[T]> {
        return map({ (response) -> [T] in
            let object = try LSMoyaProviderDecodable.decodableArrayObject(data: response.data,type: T.self,decoder: decoder,keyPath: keyPath)
            return object
        }).catch { (err) -> Observable<[T]> in
            return Observable<[T]>.create({ (observe) -> Disposable in
                observe.onError(moyaFinalError(error: err))
                return Disposables.create()
            })}
    }

    func mapToDict() -> Observable<[String: Any]> {
        return map({ (response) -> [String: Any] in
            let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
            if let dict = json as? [String: Any] {
                return dict
            }
            throw LSMoyaError.serverDataError
        }).catch { (err) -> Observable<[String: Any]> in
            return Observable<[String: Any]>.create({ (observe) -> Disposable in
                observe.onError(moyaFinalError(error: err))
                return Disposables.create()
            })}
    }
    
    private func moyaFinalError(error: Error) -> LSMoyaError {
        var finalError = LSMoyaError.server("-1", "网络异常，请稍后再试", [:])
        if let error = error as? MoyaError, let reponse = error.response {
            if reponse.statusCode == NSURLErrorTimedOut {
                finalError = LSMoyaError.timeOut
            }
        } else if let error = error as? LSMoyaError {
            finalError = error
        }
        return finalError
        
    }
  
}

