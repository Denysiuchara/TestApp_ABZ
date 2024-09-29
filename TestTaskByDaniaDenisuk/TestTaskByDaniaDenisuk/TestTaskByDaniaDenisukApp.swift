//
//  TestTaskByDaniaDenisukApp.swift
//  TestTaskByDaniaDenisuk
//
//  Created by Danya Denisiuk on 26.09.2024.
//

import SwiftUI

@main
struct TestTaskByDaniaDenisukApp: App {
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            TaskZStack {
                try? await Task.sleep(for: .seconds(3))
            } inProgressView: {
                LaunchSreen()
            } inCompletedView: {
                GetRequestView()
                    .environment(networkMonitor)
            }
            .preferredColorScheme(.light)
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                UIApplication
                    .shared
                    .sendAction(
                        #selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil
                    )
            }
        }
    }
}
