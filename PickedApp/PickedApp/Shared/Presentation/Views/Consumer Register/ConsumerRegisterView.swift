import SwiftUI

/// A view that displays a registration form for consumers.
struct ConsumerRegisterView: View {
    
    // MARK: - Properties
    
    @Environment(AppStateVM.self) private var appState // Access to app state
    @State private var viewModel: ConsumerRegisterViewModel // ViewModel for consumer registration
    
    // User input state
    @State var username = "" // Username input
    @State var email = "" // Email input
    @State var password = "" // Password input
    
    // Alert state
    @State private var showAlert = false // Determines if the alert is shown
    @State private var alertMessage = "" // Alert message
    
    // MARK: - Initialization
    
    /// Initializes the view with the app state.
    init(appState: AppStateVM) {
        _viewModel = State(initialValue: ConsumerRegisterViewModel(appState: appState))
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            
            // App logo
            Image(.logotipo)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            // Screen title
            Text("Consumer Register")
                .font(.title.bold())
                .foregroundStyle(.white)
            
            VStack(spacing: 10) {
                
                // Username input field
                IconTextFieldView(
                    iconName: "person.fill",
                    placeholder: "Username",
                    text: $username,
                    keyboardType: .default
                )
                
                // Email input field
                IconTextFieldView(
                    iconName: "envelope.fill",
                    placeholder: "Email",
                    text: $email,
                    keyboardType: .emailAddress
                )
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                
                // Password input field
                IconSecureFieldView(
                    icon: "lock.fill",
                    placeholder: "Password",
                    password: $password
                )
                
                // Sign up button
                CustomButtonView(title: "Sign Up", color: .secondaryColor) {
                    Task {
                        
                        // Validate fields and handle registration
                        if let error = await viewModel.consumerRegister(name: username, email: email, password: password, role: "consumer") {
                            alertMessage = error
                            showAlert = true
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.primaryColor)
        .alert("Consumer Register", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage) // Displays error message in alert
        }
    }
}

#Preview {
    ConsumerRegisterView(appState: AppStateVM())
        .environment(AppStateVM()) // Previews the view with app state
}
