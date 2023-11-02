//
//  DynamicAuthReal.swift
//  GuideBook
//
//  Created by Yegor Myropoltsev on 27.10.2023.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    private enum Focus {
        case email, password
    }
    
    @FocusState private var focus: Focus?
    
    private var isAbleToSignIn: Bool {
        !authVM.email.isEmpty && !authVM.password.isEmpty
    }
    
    private var isAbleToSignUp: Bool {
        !authVM.username.isEmpty && !authVM.email.isEmpty && !authVM.password.isEmpty && authVM.isPasswordsMatched()
    }
    
    private var isUserNotFound: Bool {
        !authVM.email.isEmpty &&
        authVM.didLoginButtonClicked &&
        (!authVM.isEmailValid(authVM.email) || authVM.errorResponse?.code == RequestError.userNotFound.rawValue) &&
        authVM.isSignIn &&
        authVM.isWarningsShown
    }
    
    private var isEmailNotUnique: Bool {
        !authVM.email.isEmpty &&
        !authVM.isEmailValid(authVM.email) &&
        authVM.didLoginButtonClicked &&
        authVM.errorResponse?.code == RequestError.emailNotUnique.rawValue &&
        !authVM.isSignIn &&
        authVM.isWarningsShown
    }
    
    private var isEmailInvalid: Bool {
        !authVM.email.isEmpty &&
        !authVM.isEmailValid(authVM.email) &&
        authVM.didLoginButtonClicked &&
        authVM.isWarningsShown
    }
    
    private var isInvalidPassword: Bool {
        !authVM.password.isEmpty &&
        authVM.didLoginButtonClicked &&
        authVM.errorResponse?.code == RequestError.invalidPassword.rawValue &&
        authVM.isSignIn &&
        authVM.isWarningsShown
    }
    
    private var isUsernameNotUnique: Bool {
        !authVM.username.isEmpty &&
        !authVM.isUsernameValid(authVM.username) &&
        authVM.didLoginButtonClicked &&
        authVM.errorResponse?.code == RequestError.usernameNotUnique.rawValue &&
        !authVM.isSignIn &&
        authVM.isWarningsShown
    }
    
    private var isUsernameInvalid: Bool {
        !authVM.username.isEmpty &&
        authVM.didLoginButtonClicked &&
        !authVM.isUsernameValid(authVM.username) &&
        authVM.isWarningsShown
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack {
                headerSection
                
                if authVM.isSignIn {
                    withAnimation(.bouncy) {
                        signIn
                    }
                } else {
                    withAnimation(.bouncy) {
                        signUp
                    }
                }
                
                if !authVM.isSignIn {
                    usernameField
                    if isUsernameInvalid {
                        HStack {
                            invalidUsername
                            Spacer()
                        }
                    } else if isUsernameNotUnique {
                        HStack {
                            usernameNotUnique
                            Spacer()
                        }
                    }
                }
                
                emailField
                if isEmailInvalid {
                    HStack {
                        invalidEmail
                        Spacer()
                    }
                } else if isUserNotFound {
                    HStack {
                        userNotFound
                        Spacer()
                    }
                } else if isEmailNotUnique {
                    HStack {
                        emailNotUnique
                        Spacer()
                    }
                }
                
                passwordField
                if isInvalidPassword {
                    HStack {
                        invalidPassword
                        Spacer()
                    }
                }
                
                if !authVM.isSignIn {
                    confirmPasswordField
                }
                
                Spacer()
                
                loginButton
                switchAuthMode
                
            }
            .padding(30)
            
        }
    }
}

extension AuthView {
    
    private func errorText(_ message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .font(.system(size: 16))
    }
    
    private var usernameNotUnique: some View {
        errorText("Username not unique")
    }
    
    private var emailNotUnique: some View {
        errorText("Email not unique")
    }
    
    private var invalidPassword: some View {
        errorText("Invalid password")
    }
    
    private var userNotFound: some View {
        errorText("User not found")
    }
    
    private var invalidUsername: some View {
        errorText("Invalid username")
    }
    
    private var invalidEmail: some View {
        errorText("Invalid email address")
    }
    
    private var headerSection: some View {
        Text("📘 GuideBook")
            .font(.system(size: 21))
            .bold()
    }
    

    
    private var signIn: some View {
        HStack {
            Text("Sign in")
                .font(.system(size: 36))
                .padding([.bottom, .top], 30)
            Spacer()
        }
        .transition(.slide.combined(with: .opacity))
    }
    
    private var signUp: some View {
        HStack {
            Text("Sign up")
                .font(.system(size: 36))
                .padding([.bottom, .top], 30)
            Spacer()
        }
        .transition(.slide.combined(with: .opacity))
    }
    
    private var usernameField: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, minHeight: 50)
            .shadow(radius: 1)
            .overlay(
                TextField(
                    "SignIn.UsernameField.Title",
                    text: $authVM.username
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.system(size: 18))
                .padding(.horizontal, 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isUsernameNotUnique
                        ? Color.red : Color.clear, lineWidth: 2
                    )
            )
            .padding(.top, 20)
    }
    
    private var emailField: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, minHeight: 50)
            .shadow(radius: 1)
            .overlay(
                TextField(
                    "SignIn.EmailField.Title",
                    text: $authVM.email
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .font(.system(size: 17))
                .padding(.horizontal, 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isEmailNotUnique || isUserNotFound
                        ? Color.red : Color.clear, lineWidth: 2
                    )
            )
            .padding(.top, 10)
    }
    
    private var passwordField: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, minHeight: 50)
            .shadow(radius: 1)
            .overlay(
                PasswordField(
                    placeholder: "SignIn.PasswordField.Title",
                    text: $authVM.password
                )
                .focused($focus, equals: .password)
                .font(.system(size: 17))
                .padding(.horizontal, 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isInvalidPassword &&
                        authVM.password != authVM.confirmPassword
                        ? Color.red : Color.clear, lineWidth: 2
                    )
            )
            .padding(.top, 10)
    }
    
    private var confirmPasswordField: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color("FieldColor"))
            .frame(maxWidth: .infinity, minHeight: 50)
            .shadow(radius: 1)
            .overlay(
                PasswordField(
                    placeholder: "SignIn.ConfirmPasswordField.Title",
                    text: $authVM.confirmPassword
                )
                .focused($focus, equals: .password)
                .font(.system(size: 17))
                .padding(.horizontal, 10)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        !authVM.confirmPassword.isEmpty &&
                        authVM.didLoginButtonClicked &&
                        !authVM.isSignIn &&
                        authVM.password != authVM.confirmPassword
                        ? Color.red : Color.clear, lineWidth: 2
                    )
            )
            .padding(.top, 10)
            .padding(.bottom, 20)
            .transition(.asymmetric(
                insertion: .move(edge: .top), removal: .identity)
            )
    }
    
    
    
    private var loginButton: some View {
        LoadingButtonStyle(isSignIn: authVM.isSignIn, isLoading: authVM.isRequestInProgress) {
            authVM.didLoginButtonClicked = true
            authVM.isWarningsShown = true
            authVM.errorResponse = nil
            
            let authType: AuthType = authVM.isSignIn ? .signIn : .signUp
            authVM.isRequestInProgress = true
            switch authType {
            case .signIn:
                authVM.signIn(authRequest: SignInRequest(
                    email: authVM.email,
                    password: authVM.password)
                )
            case .signUp:
                authVM.signUp(authRequest: SignUpRequest(
                    username: authVM.username,
                    email: authVM.email,
                    password: authVM.password)
                )
                authVM.isRequestInProgress = false
                authVM.isWarningsShown = false

            }
        }
        .disabled(authVM.isSignIn ? !isAbleToSignIn : !isAbleToSignUp)
        .opacity((authVM.isSignIn ? isAbleToSignIn : isAbleToSignUp) ? 1 : 0.5)
        .padding(.top, 20)
    }
    
    private var switchAuthMode: some View {
        HStack {
            Text(authVM.isSignIn ? "Don't have an account?" :"Already have an account?")
                .padding([.bottom, .top, .leading], 20)
            Text(authVM.isSignIn ? "Sign up" : "Sign in")
                .foregroundStyle(.blue)
                .padding([.bottom, .top, .trailing], 20)
                .onTapGesture {
                    withAnimation(.snappy) {
                        authVM.isSignIn.toggle()
                    }
                }
        }
        .padding(.bottom, 30)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(GuideViewModel())
            .environmentObject(AuthViewModel())
    }
}
