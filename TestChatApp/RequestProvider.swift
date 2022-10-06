//
//  RequestProvider.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import Moya
import RxSwift

class RequestProvider<Target: TargetType>: MoyaProvider<Target> {

    override init(endpointClosure: @escaping EndpointClosure = RequestProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = RequestProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = RequestProvider.neverStub,
         callbackQueue: DispatchQueue? = nil,
         session: Session = RequestProvider<Target>.defaultAlamofireSession(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false)
    {

        super.init(endpointClosure: endpointClosure,
                   requestClosure: requestClosure,
                   stubClosure: stubClosure,
                   callbackQueue: callbackQueue,
                   session: session,
                   plugins: plugins,
                   trackInflights: trackInflights)
    }
}

extension Reactive where Base: MoyaProviderType {

    func retriableRequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return self.request(token, callbackQueue: callbackQueue)
    }
}
