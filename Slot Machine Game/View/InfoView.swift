//
//  InfoView.swift
//  Slot Machine Game
//
//  Created by Emile Wong on 1/7/2021.
//

import SwiftUI

struct InfoView: View {
    // MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("About the application")) {
                    FormRowView(firstItem: "Application", secondItem: "Slot Machine Game")
                    FormRowView(firstItem: "Pathform", secondItem: "iPhone, iPad, Mac")
                    FormRowView(firstItem: "Developer", secondItem: "Emile Wong")
                    FormRowView(firstItem: "Designer", secondItem: "Robert Petras")
                    FormRowView(firstItem: "Music", secondItem: "Don Lebowitz")
                    FormRowView(firstItem: "Website", secondItem: "www.emilewong.com")
                    FormRowView(firstItem: "Copyright", secondItem: "© 2021 All Right Reserved")
                    FormRowView(firstItem: "Version", secondItem: "1.0.0")
                }
            } //: FORM
            .font(.system(.body, design: .rounded))
        } //: VSTACK
        .padding(.top, 40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .accentColor(Color.secondary)
            , alignment: .topTrailing
            )
            .onAppear(perform: {
                playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct FormRowView: View {
    // MARK: - PROPERTIES
    var firstItem: String
    var secondItem: String
    // MARK: - BODY
    var body: some View {
        HStack {
            Text(self.firstItem)
                .foregroundColor((Color.gray))
            Spacer()
            Text(self.secondItem)
        }
    }
}

// MARK: - PREVIEW
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

