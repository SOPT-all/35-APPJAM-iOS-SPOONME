//
//  ExploreTargetType.swift
//  Spoony-iOS
//
//  Created by 이명진 on 1/20/25.
//

import Foundation
import Moya

enum ExploreTargetType {
    case getUserFeeds(userId: Int, location: String, sort: FilterType)
    case reportPost(postId: Int, userId: Int, reportType: ReportType, reportDetail: String)
    case getCategories
}

extension ExploreTargetType: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: Config.baseURL) else {
            fatalError("baseURL could not be configured")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .getUserFeeds(let userId, _, _):
            return "/feed/\(userId)"
        case .reportPost:
            return "/report"
        case .getCategories:
            return "/post/categories"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserFeeds,
                .getCategories:
            return .get
        case .reportPost:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .getUserFeeds(_, location, filter):
            let params: [String: String] = [
                "query": location,
                "sortBy": filter.rawValue
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getCategories:
            return .requestPlain
        case .reportPost:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return Config.defaultHeader
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
