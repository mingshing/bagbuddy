//
//  ChatGPTAPIService.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Moya

let ChatGPTAPIServiceProvider = MoyaProvider<ChatGPTAPIService>()
//let ChatGPTAPIServiceProvider = MoyaProvider<ChatGPTAPIService>(stubClosure: MoyaProvider.delayedStub(0.2))


enum ChatGPTAPIService {
    
    case request(token: String)

}

extension ChatGPTAPIService: TargetType {
    
    var baseURL: URL {
        return URL(string: HostAppContants.chatGPTUrl)!
    }
    
    var path: String {
        switch self {
        case .request:
            return "users"
        }
    }
    
    var method: Method {
        switch self {
        case .request:
            return .post
        }
    }
    
    var sampleData: Data {
        switch self {
        case .request(_):
            guard let url = Bundle.main.url(forResource: "ChatGPTResponse", withExtension: "json"),
                  let data = try? Data(contentsOf: url) else {
                return Data()
            }
            return data
        }
    }
    
    var task: Task {
        switch self {
        case .request:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
