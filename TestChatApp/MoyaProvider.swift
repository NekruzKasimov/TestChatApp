//
//  MoyaProvider.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Moya
import Resolver

// MARK: - BaseService with Codable

protocol MoyaRequest {
    associatedtype CodableRoot: Codable
    associatedtype CustomError: Error
    
    func parseData(_ data: Data)
    func parseError(_ moyaError: MoyaError)
    
    var onSuccess: (CodableRoot) -> Void { get }
    var onFailure: (CustomError) -> Void { get }
}

extension MoyaRequest {
    private func thereIs(_ data: Data) -> Bool {
        let decoder = JSONDecoder()
        if !data.isEmpty {
            return true
        } else {
            if let emptyJSONObjectData = "{}".data(using: .utf8),
                 let emptyDecodableValue = try? decoder.decode(CodableRoot.self, from: emptyJSONObjectData) {
                onSuccess(emptyDecodableValue)
            } else if let emptyJSONArrayData = "[{}]".data(using: .utf8),
                                let emptyDecodableValue = try? decoder.decode(CodableRoot.self, from: emptyJSONArrayData) {
                onSuccess(emptyDecodableValue)
            }
            return false
        }
    }
    
    func parseData(_ data: Data) {
        guard thereIs(data) else { return }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let rootObject = try decoder.decode(CodableRoot.self , from: data)
            onSuccess(rootObject)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("Failed to decode due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            print("Failed to decode due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            print("Failed to decode due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            print("Failed to decode because it appears to be invalid JSON")
        } catch {
            print("Failed to decode : \(error.localizedDescription)")
        }
    }
    
    func parseError(_ moyaError: MoyaError) {
        switch MoyaError.self == CustomError.self {
        case true:
            let moyaError = moyaError as! CustomError
            onFailure(moyaError)
        case false:
            guard let errorData = moyaError.response?.data else { return }
            print("Unserialized error data",errorData)
        // Serialize the errorData
        }
    }
    
    private func onMoyaRequestCompletion(_ result: Result<Moya.Response, MoyaError>) {
        let defaultEntryDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .short
            return formatter
        }()
        
        let entry:(String,String) -> String = { (identifier, message) in
            let date = defaultEntryDateFormatter.string(from: Date())
            return """
            ---------------------------------------------------------------------------------------------
            ||| Moya_Logger: [\(date)] \(identifier):\n\(message)
            ---------------------------------------------------------------------------------------------
            """
        }
        
        func printResponse(for response: Moya.Response?) {
            guard let response = response else { return }
            let message = """
            ||| [ Status Code: \(response.statusCode) ]
            ||| [ Method: \(response.request?.httpMethod ?? "Method is unknown")]
            ||| [ URL: \(response.request?.url?.description ?? "Path is unknown")]
            """
            print(entry("Response: ", message))
        }
        
        func printData(for response: Moya.Response) {
            let responseData = String(data: response.data, encoding: .utf8) ?? "No response data"
            let wI = NSMutableString(string: responseData)
            CFStringTransform(wI, nil, "Any-Hex/Java" as NSString, true)
            print("Response data: ", wI)
        }
        
        switch result {
        case let .success(response):
            printResponse(for: response)
            parseData(response.data)
        case let .failure(moyaError):
            printResponse(for: moyaError.response)
            parseError(moyaError)
        }
    }
}

var multiProvider = MoyaProvider<MultiTarget>()

extension MoyaRequest where Self: TargetType {
    func dispatch() -> Cancellable {
        let multiTarget = MultiTarget(self)
        return multiProvider.request(multiTarget, completion: onMoyaRequestCompletion)
    }
}

// MARK: - Kompanion request defaults

protocol KompRequest: TargetType, AccessTokenAuthorizable { }

extension KompRequest {
    var baseURL: URL { Config.baseUrl }
}

extension KompRequest {
    var path: String                                { return "/" }
    var method: Moya.Method                         { return .get }
    var task: Task                                  { return .requestPlain }
    var headers: [String : String]?                 { return nil }
    var validationType: ValidationType              { return .successCodes }
    var sampleData: Data                            { return Data("Sample Data".utf8) }
}
