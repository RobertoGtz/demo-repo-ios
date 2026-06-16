import SwiftUI

struct PromotionalBannerView: View {
    let title: String
    let subtitle: String
    let ctaTitle: String
    let onCTATap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: onCTATap) {
                Text(ctaTitle)
                    .font(.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct PromotionalBannerView_Previews: PreviewProvider {
    static var previews: some View {
        PromotionalBannerView(
            title: "Special Offer!",
            subtitle: "Get 50% off on your first purchase.",
            ctaTitle: "Shop Now",
            onCTATap: { print("CTA tapped") }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}