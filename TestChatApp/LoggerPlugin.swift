//
//  LoggerPlugin.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation
import Moya

struct LoggerPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
            print("----\nREQUEST: \(request.request?.httpMethod ?? "") \(request.request?.url?.absoluteString ?? "")")
            if let body = request.request?.httpBody {
                if let responseData = String(data: body, encoding: .utf8) {
                    let finalString = NSMutableString(string: responseData)
                    CFStringTransform(finalString, nil, "Any-Hex/Java" as NSString, true)
                    print("BODY:", responseData)
                }
            }
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
                    let code = response.statusCode
                    print("RESPONSE: \(response.request?.urlRequest?.url?.absoluteString ?? "") Code: \(code)\n\((try? response.mapString()) ?? "")\n----\n")
        case .failure(let error):
                    let url = error.response?.request?.urlRequest?.url?.absoluteString ?? ""
                    let data = (try? error.response?.mapString()) ?? ""
                    let code = (error.response?.statusCode) ?? 0
                    print("ERROR: \(url) \(code)\nError data:\(data)\n\(error.localizedDescription)\n----\n")
        }
        return result
    }
}
