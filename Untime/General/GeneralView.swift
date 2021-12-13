import SwiftUI

/// GenerelView represents the third tab with generel settings for the app.
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
