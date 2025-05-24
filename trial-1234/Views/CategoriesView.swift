import SwiftUI

struct CategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var categoryViewModel = CategoryViewModel()
    
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
                        ForEach(categoryViewModel.categories) { category in
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
                AddCategoryView(categoryViewModel: categoryViewModel)
            }
            .onAppear {
                categoryViewModel.fetchCategories()
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
    @ObservedObject var categoryViewModel: CategoryViewModel
    @State private var categoryName = ""
    @State private var selectedIcon = "tag.fill"
    @State private var selectedColor = Color.blue
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    
    // Sample icons
    let icons = [
        "tag.fill", "laptopcomputer", "doc.fill", "key.fill",
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
                        saveCategory()
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Save Category")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .standardButtonStyle()
                    .disabled(categoryName.isEmpty || isLoading)
                    .opacity((categoryName.isEmpty || isLoading) ? 0.7 : 1)
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
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
    
    private func saveCategory() {
        isLoading = true
        errorMessage = nil
        
        // Create a new category with a unique ID
        let newCategory = Category(id: UUID().uuidString,
                                 name: categoryName,
                                 icon: selectedIcon,
                                 color: selectedColor)
        
        // Add the category to the view model
        categoryViewModel.addCategory(category: newCategory)
        
        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    CategoriesView()
}
