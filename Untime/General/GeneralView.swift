//
//  GeneralView.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 08.12.21.
//

import SwiftUI

struct GeneralView: View {
    
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Tags") {
                    TagListView()
                }
            }
            .navigationBarTitle("General")
            .navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
