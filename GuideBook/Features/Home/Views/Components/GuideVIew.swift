import SwiftUI

struct GuideVIew: View {
    let item: Guide
    
    var body: some View {
        HStack {
            Text(item.emoji)
                .font(.system(size: 35))
                .padding([.top,.bottom,.trailing], 10)
            VStack(alignment: .leading) {
                Text(item.title)
                    .lineLimit(1)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                Text(item.description)
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct GuideVIew_Previews: PreviewProvider {    
    static var testItems: Guide = Guide(
        id: "bs9d8f908s7dv9usdf",
        title: "Guide",
        description: "Dive into data science with Python",
        emoji: "🐍"
        
    )
    
    static var previews: some View {
        GuideVIew(item: testItems)
            .previewLayout(.sizeThatFits)
    }
}
