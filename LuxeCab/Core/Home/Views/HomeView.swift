//
//  HomeView.swift
//  LuxeCab
//
//  Created by JJMac on 08/06/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showLocationSearchView = false
    var body: some View {
        ZStack(alignment: .top) {
            LCMapViewRepresentable().ignoresSafeArea()
            
            if showLocationSearchView {
                LocationSearchView(showLocationSearchView: $showLocationSearchView)
            }else{
                LocationSearchActivationView().padding(.top,72)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showLocationSearchView.toggle()
                        }
                    }
            }
            
            MapViewActionButton(showLocationSearchView: $showLocationSearchView)
                .padding(.leading)
                .padding(.top,4)
        }
    }
}

#Preview {
    HomeView()
}
