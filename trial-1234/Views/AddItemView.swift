import SwiftUI
import PhotosUI

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var itemViewModel = ItemViewModel()
    @State private var itemName = ""
    @State private var itemLocation = ""
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var isFavorite = false
    // No need for this state variable as we're creating a new item directly
    // @State private var item: Item? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Item name field
                    TextField("Item Name", text: $itemName)
                        .standardTextFieldStyle()
                    
                    // Item location field
                    TextField("Location", text: $itemLocation)
                        .standardTextFieldStyle()
                    
                    // Photo section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Add a Photo (Optional)")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(Constants.Dimensions.cornerRadius)
                                .overlay(
                                    Button(action: {
                                        self.selectedImage = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 24))
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.7)))
                                    }
                                    .padding(8),
                                    alignment: .topTrailing
                                )
                        } else {
                            Button(action: {
                                showImagePicker = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                                        .fill(Constants.Colors.lightBackground)
                                        .frame(height: 200)
                                    
                                    VStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 32))
                                            .foregroundColor(.white)
                                        
                                        Text("Tap to add a photo")
                                            .font(.system(size: Constants.FontSizes.body))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Add to favorites option
                    HStack {
                        Text("Add to Favorites")
                            .font(.system(size: Constants.FontSizes.body))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isFavorite)
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        // Create a new item with the favorite status
                        let photoUrl = selectedImage != nil ? "photo_url_placeholder" : nil
                        itemViewModel.addItem(name: itemName, location: itemLocation, photoUrl: photoUrl)
                        
                        // If favorite is set, toggle it after item is created
                        if isFavorite {
                            // In a real app, we would get the created item and toggle its favorite status
                            // For now, we'll just simulate this behavior
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                if let lastItem = itemViewModel.items.last {
                                    itemViewModel.toggleFavorite(for: lastItem)
                                }
                            }
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Item")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(itemName.isEmpty || itemLocation.isEmpty || itemViewModel.isLoading)
                    .opacity((itemName.isEmpty || itemLocation.isEmpty || itemViewModel.isLoading) ? 0.7 : 1)
                    
                    // Error message
                    if let error = itemViewModel.error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: Constants.FontSizes.caption))
                    }
                }
                .padding()
                .navigationTitle("Add Item")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .photosPicker(isPresented: $showImagePicker, selection: $photoPickerItem, matching: .images)
            .onChange(of: photoPickerItem) { oldValue, newValue in
                Task(priority: .userInitiated) {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
    

}

#Preview {
    AddItemView()
}
