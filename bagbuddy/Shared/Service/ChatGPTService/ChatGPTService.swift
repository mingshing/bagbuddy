//
//  ChatGPTService.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Foundation


class ChatGPTService {
    
    public static func getResponseFromChatGPT(for token: String, completion: @escaping( Result<ChatGPTResponse, Error>) -> ()) {
        
        
        ChatGPTAPIServiceProvider.request(.request(token: token)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = try JSONDecoder().decode(ChatGPTResponse.self, from: filteredResponse.data)
                    
                    completion(.success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
