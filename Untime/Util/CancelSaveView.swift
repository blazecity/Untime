//
//  CancelSaveView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct CancelSaveView: View {
    var title: String = ""
    var cancelAction: () -> Void
    var saveAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                cancelAction()
            } label: {
                Text("Cancel").bold()
            }.buttonStyle(BorderlessButtonStyle())
            if title != "" {
                Spacer()
                Text(title).bold().font(.system(size: 17))
                Spacer()
            } else {
                Spacer()
            }
            Button {
                saveAction()
            } label: {
                Text("Save").bold()
            }.buttonStyle(BorderlessButtonStyle())
        }.padding()
    }
}

struct CancelSaveView_Previews: PreviewProvider {
    static var previews: some View {
        CancelSaveView {
            print("Cancelling...")
        } saveAction: {
            print("Saving...")
        }

    }
}
