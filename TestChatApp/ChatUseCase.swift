//
//  ChatUseCase.swift
//  TestChatApp
//
//  Created by Niko on 05.10.22.
//

import Foundation

import Moya
import Resolver
import RxSwift

extension Resolver {

    static func registerChatUseCase() {
        register(IChatUseCase.self) { ChatUseCase(
            baseUrl: $0.resolve(name: .baseUrl)) }
    }
}

protocol IChatUseCase {

    func chats() -> Single<[ChatModel]>
}


private enum ChatService: TargetType {

    case chats(baseUrl: URL)

    var baseURL: URL {
        switch self {
        case .chats(let baseUrl):
            return baseUrl
        }
    }

    var path: String {
        switch self {
        case .chats(_):
            return "/api/files/message.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .chats:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .chats:
            return .requestPlain
        }
    }

    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }

    var authorizationType: AuthorizationType? {
        return .bearer
    }
}

private struct ChatUseCase: IChatUseCase {
    let baseUrl: URL
    let provider: RequestProvider<ChatService>

    init(baseUrl: URL) {
        self.baseUrl = Config.baseUrl
        self.provider = RequestProvider(
            plugins: [
                LoggerPlugin()
            ])
    }
    
    func chats() -> Single<[ChatModel]> {
        self.provider.rx.request(.chats(baseUrl: baseUrl))
            .map([ChatModel].self, atKeyPath: "chats")
    }
}
