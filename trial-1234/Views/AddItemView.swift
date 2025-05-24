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
                        
                        Toggle("", isOn: .constant(false))
                            .toggleStyle(SwitchToggleStyle(tint: Constants.Colors.primaryPurple))
                    }
                    .padding()
                    .background(Constants.Colors.lightBackground)
                    .cornerRadius(Constants.Dimensions.cornerRadius)
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        saveItem()
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
            .onChange(of: photoPickerItem) { oldItem, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        // For now, just simulate adding an item and dismiss
        // In a real app, this would call the itemViewModel.addItem method
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    AddItemView()
}
