import SwiftUI

struct CategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Sample categories for preview
    let categories = [
        Category(id: "1", name: "Electronics", icon: "laptopcomputer", color: .blue),
        Category(id: "2", name: "Documents", icon: "doc.fill", color: .green),
        Category(id: "3", name: "Keys", icon: "key.fill", color: .yellow),
        Category(id: "4", name: "Accessories", icon: "eyeglasses", color: .purple),
        Category(id: "5", name: "Clothing", icon: "tshirt.fill", color: .red),
        Category(id: "6", name: "Wallet", icon: "creditcard.fill", color: .orange)
    ]
    
    @State private var showAddCategorySheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Grid of categories
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(categories) { category in
                            CategoryCell(category: category)
                        }
                        
                        // Add category button
                        Button(action: {
                            showAddCategorySheet = true
                        }) {
                            VStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                                
                                Text("Add Category")
                                    .font(.system(size: Constants.FontSizes.body))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.Colors.lightBackground)
                            .cornerRadius(Constants.Dimensions.cornerRadius)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Categories")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .sheet(isPresented: $showAddCategorySheet) {
                AddCategoryView()
            }
        }
    }
}

struct Category: Identifiable {
    let id: String
    let name: String
    let icon: String
    let color: Color
}

struct CategoryCell: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Image(systemName: category.icon)
                    .font(.system(size: 24))
                    .foregroundColor(category.color)
            }
            
            Text(category.name)
                .font(.system(size: Constants.FontSizes.body))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Constants.Colors.lightBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
    }
}

struct AddCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var categoryName = ""
    @State private var selectedIcon = "tag.fill"
    @State private var selectedColor = Color.blue
    
    // Sample icons
    let icons = [
        "tag.fill", "folder.fill", "paperclip", "doc.fill", "book.fill",
        "creditcard.fill", "key.fill", "laptopcomputer", "desktopcomputer",
        "headphones", "tv.fill", "gamecontroller.fill", "car.fill",
        "bicycle", "tshirt.fill", "eyeglasses", "bag.fill"
    ]
    
    // Sample colors
    let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Constants.Colors.darkBackground
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.Dimensions.standardPadding) {
                    // Category preview
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(selectedColor.opacity(0.2))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: selectedIcon)
                                .font(.system(size: 32))
                                .foregroundColor(selectedColor)
                        }
                        
                        Text(categoryName.isEmpty ? "New Category" : categoryName)
                            .font(.system(size: Constants.FontSizes.title, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, Constants.Dimensions.standardPadding * 2)
                    
                    // Category name field
                    TextField("Category Name", text: $categoryName)
                        .standardTextFieldStyle()
                    
                    // Icon selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Icon")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 16) {
                            ForEach(icons, id: \.self) { icon in
                                Button(action: {
                                    selectedIcon = icon
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Constants.Colors.lightBackground)
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedIcon == icon ? selectedColor : .white)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Color selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Color")
                            .font(.system(size: Constants.FontSizes.body, weight: .medium))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 16) {
                            ForEach(colors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(color)
                                            .frame(width: 30, height: 30)
                                        
                                        if color == selectedColor {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 36, height: 36)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Save button
                    Button(action: {
                        // Save category logic would go here
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Category")
                            .frame(maxWidth: .infinity)
                    }
                    .standardButtonStyle()
                    .disabled(categoryName.isEmpty)
                    .opacity(categoryName.isEmpty ? 0.7 : 1)
                }
                .padding()
                .navigationTitle("Add Category")
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
        }
    }
}

#Preview {
    CategoriesView()
}
