//
//  ChatGPTService.swift
//  bagbuddy
//
//  Created by mingshing on 2023/4/23.
//

import Foundation


class ChatGPTService {
    
    public static func getResponseFromChatGPT(for token: String, completion: @escaping(String, Result<NotificationItemsResponse, ApiError>) -> ()) {
        
        
        ChatGPTAPIService.request(.request(token: token)) { result in
            switch result {
            case let .success(response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusAndRedirectCodes()
                    let result = try JSONDecoder().decode(NotificationItemsResponse.self, from: filteredResponse.data)
                    
                    completion(userId, .success(result))
                } catch _ {
                    
                    let errorResponse = String(decoding: response.data, as: UTF8.self)
                    print("[API Error: \(#function)] \(errorResponse)")
                    
                    switch response.statusCode {
                    case 401:
                        completion(userId, .failure(ApiError.UnAuthorize))
                    default:
                        completion(userId, .failure(ApiError.ServerError(reason: errorResponse)))
                    }
                }
            case .failure(_):
                completion(userId, .failure(ApiError.Network))
            }
        }
    }
