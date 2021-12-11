//
//  ReportingEntryView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 06.12.21.
//

import SwiftUI

struct ReportingEntryView: View {
    var body: some View {
        HStack {
            Text("ID 414")
            Spacer()
            Text("2.5h")
        }
        .padding()
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              alignment: .topLeading
        )
    }
}

struct ReportingEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ReportingEntryView()
    }
}
