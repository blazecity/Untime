import SwiftUI

/// GenerelView represents the third tab with generel settings for the app.
struct GeneralView: View {
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(String(localized: "list_title_tags")) {
                    TagListView()
                }
            }
            .navigationBarTitle(String(localized: "tab_general_title"))
            //.navigationBarTitleDisplayMode(.inline)
            
        }
        
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
