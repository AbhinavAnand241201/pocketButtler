import SwiftUI

struct CategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CategoryViewModel()
    @State private var showAddCategorySheet = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Content
                mainContentView
                    .navigationTitle("Categories")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            backButton
                        }
                    }
            }
        }
        .sheet(isPresented: $showAddCategorySheet) {
            AddCategoryView(categoryViewModel: viewModel)
        }
        .onAppear {
            viewModel.fetchCategories()
        }
    }
    
    private var mainContentView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.categories) { category in
                    CategoryCell(category: category)
                }
                addButton
            }
            .padding()
        }
    }
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        }
    }
    
    private var addButton: some View {
        Button(action: { showAddCategorySheet = true }) {
            VStack(spacing: 16) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Theme.Colors.primaryButton)
                
                Text("Add Category")
                    .font(.system(size: Constants.FontSizes.body))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, minHeight: 150)
            .padding()
            .background(Theme.Colors.cardBackground)
            .cornerRadius(Constants.Dimensions.cornerRadius)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Models and Subviews

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
            iconView
            nameView
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.Colors.cardBackground)
        .cornerRadius(Constants.Dimensions.cornerRadius)
    }
    
    private var iconView: some View {
        ZStack {
            Circle()
                .fill(category.color.opacity(0.2))
                .frame(width: 60, height: 60)
            
            Image(systemName: category.icon)
                .font(.system(size: 24))
                .foregroundColor(category.color)
        }
    }
    
    private var nameView: some View {
        Text(category.name)
            .font(.system(size: Constants.FontSizes.body))
            .foregroundColor(Theme.Colors.textPrimary)
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
    private let icons = [
        "tag.fill", "laptopcomputer", "doc.fill", "key.fill",
        "bicycle", "tshirt.fill", "eyeglasses", "bag.fill"
    ]
    
    // Sample colors
    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Theme.Colors.backgroundStart, Theme.Colors.backgroundEnd]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content
                mainContentView
                    .navigationTitle("Add Category")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(Theme.Colors.textPrimary)
                            }
                        }
                    }
            }
        }
    }
    
    private var mainContentView: some View {
        VStack(spacing: Constants.Dimensions.standardPadding) {
            // Category preview
            categoryPreview
            
            // Category name field
            TextField("Category Name", text: $categoryName)
                .standardTextFieldStyle()
            
            // Icon selection
            iconSelectionView
            
            // Color selection
            colorSelectionView
            
            Spacer()
            
            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.system(size: Constants.FontSizes.caption))
                    .foregroundColor(.red)
                    .padding(.bottom, 8)
            }
            
            // Save button
            saveButton
        }
        .padding()
    }
    
    private var categoryPreview: some View {
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
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(.vertical, Constants.Dimensions.standardPadding * 2)
    }
    
    private var iconSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Icon")
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(Theme.Colors.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(icons, id: \.self) { icon in
                        Button(action: { selectedIcon = icon }) {
                            ZStack {
                                Circle()
                                    .fill(selectedIcon == icon ? selectedColor.opacity(0.2) : Constants.Colors.lightBackgroundColor)
                                    .frame(width: 50, height: 50)
                                
                                Image(systemName: icon)
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedIcon == icon ? selectedColor : Theme.Colors.textPrimary)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var colorSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color")
                .font(.system(size: Constants.FontSizes.caption))
                .foregroundColor(Theme.Colors.textSecondary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(colors, id: \.self) { color in
                        Button(action: { selectedColor = color }) {
                            ZStack {
                                Circle()
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                                
                                if selectedColor == color {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    private var saveButton: some View {
        Button(action: saveCategory) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text("Save Category")
                    .font(.system(size: Constants.FontSizes.body, weight: .semibold))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(Theme.Colors.primaryButton)
        .foregroundColor(Theme.Colors.textPrimary)
        .cornerRadius(Constants.Dimensions.buttonCornerRadius)
        .padding(.bottom, Constants.Dimensions.standardPadding)
        .disabled(categoryName.isEmpty || isLoading)
        .opacity(categoryName.isEmpty ? 0.7 : 1.0)
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
