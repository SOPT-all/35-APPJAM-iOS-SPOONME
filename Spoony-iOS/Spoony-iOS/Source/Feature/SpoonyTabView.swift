//
//  SpoonyTabView.swift
//  SpoonMe
//
//  Created by 최주리 on 1/7/25.
//

import SwiftUI

struct SpoonyTabView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        
        tabBarAppearance.backgroundColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.main400,
            .font: UIFont.caption2b
        ]
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray400,
            .font: UIFont.caption2b
        ]
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        
        TabView(selection: $navigationManager.selectedTab) {
            ForEach(TabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .map:
                        NavigationStack(path: $navigationManager.mapPath) {
                            Home()
                                .navigationDestination(for: ViewType.self) { view in
                                    navigationManager.build(view)
                                }
                        }
                    case .explore:
                        NavigationStack(path: $navigationManager.explorePath) {
                            Detail()
                                .navigationDestination(for: ViewType.self) { view in
                                    navigationManager.build(view)
                                }
                        }
                    case .register:
                        NavigationStack(path: $navigationManager.registerPath) {
                            Register()
                                .navigationDestination(for: ViewType.self) { view in
                                    navigationManager.build(view)
                                }
                        }
                    }
                }
                .tabItem {
                    Label(
                        tab.title,
                        image: tab.imageName(selected: navigationManager.selectedTab == tab)
                    )
                }
                .tag(tab)
            }
        }
    }
}

#Preview {
    SpoonyTabView()
        .environmentObject(NavigationManager())
}
