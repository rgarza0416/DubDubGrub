//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/21/24.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var viewModel = AppTabViewModel()
  
    
    ///THIS CODE IS FOR THE TAB BAR SO IT DOES NOT APPEAR TRANSLUCENT, THIS CODE SHOWS THE TAB BAR ON IOS16 and BELOW. IOS17 GOT A NEW MAP, WHICH WE ARE GOING TO USE
//    init() {
//        let appearance = UITabBarAppearance()
//        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
    
    var body: some View {
        TabView {
            LocationMapView()
                .tabItem { Label("Map", systemImage: "map") }
            LocationListView()
                .tabItem { Label("Locations", systemImage: "building") }
            NavigationStack { ProfileView() }
                .tabItem { Label("Profile", systemImage: "person") }
        }
        .task {
           try? await CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }

        .sheet(isPresented: $viewModel.isShowingOnboardView) {
            OnboardView()
        }
    }
       
}

#Preview {
    AppTabView()
}
