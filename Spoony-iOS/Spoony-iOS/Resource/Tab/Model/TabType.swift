//
//  TabType.swift
//  SpoonMe
//
//  Created by 최주리 on 1/7/25.
//

import Foundation

enum TabType: String, CaseIterable {
    case map
    case explore
    case register
    
    var title: String {
        switch self {
        case .map:
            return "내 지도"
        case .explore:
            return "탐색"
        case .register:
            return "등록"
        }
    }
    
    func imageName(selected: Bool) -> String {
        switch self {
        case .map:
            return selected ? "ic_map_main400" : "ic_map_gray400"
        case .explore:
            return selected ? "ic_explore_main400" : "ic_explore_gray400"
        case .register:
            return selected ? "ic_register_main400" : "ic_register_gray400"
        }
    }
}
