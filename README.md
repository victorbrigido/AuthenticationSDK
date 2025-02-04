# AuthenticationSDK

## 📌 Visão Geral

`AuthenticationSDK` é uma biblioteca Swift que fornece autenticação simplificada via **Firebase (Email/Senha)**, **Google Sign-In** e **Apple ID**, facilitando a integração da autenticação em aplicativos iOS.

## 📦 Instalação via Swift Package Manager (SPM)

Para adicionar a `AuthenticationSDK` ao seu projeto via **Swift Package Manager (SPM)**:

1. No Xcode, vá para **File > Swift Packages > Add Package Dependency**.
2. Insira a URL do repositório:
   ```
   https://github.com/victorbrigido/AuthenticationSDK.git
   ```
3. Selecione a versão desejada e clique em **Next**.
4. Escolha a opção **Add Package** para concluir a instalação.

## 🔧 Configuração do Firebase

Como `AuthenticationSDK` usa **Firebase Authentication**, é necessário configurar o Firebase no projeto:

1. Acesse o [Firebase Console](https://console.firebase.google.com/).
2. Crie um projeto (ou use um existente).
3. Vá para **Configurações do Projeto > Adicionar App (iOS)**.
4. Baixe o arquivo `GoogleService-Info.plist` e adicione à pasta raiz do seu projeto Xcode.
5. Inicialize o Firebase no seu app:

   **Para SwiftUI:**
   ```swift
   import SwiftUI
   import FirebaseCore

   @main
   struct MyApp: App {
       init() {
           FirebaseApp.configure()
       }
       var body: some Scene {
           WindowGroup {
               ContentView()
           }
       }
   }
   ```

   **Para UIKit (AppDelegate.swift):**
   ```swift
   import UIKit
   import FirebaseCore

   @UIApplicationMain
   class AppDelegate: UIResponder, UIApplicationDelegate {
       func application(
           _ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
       ) -> Bool {
           FirebaseApp.configure()
           return true
       }
   }
   ```

## 🚀 Como Usar

### 1️⃣ Configurar o `AuthenticationDelegate`
O SDK utiliza um delegate para receber os eventos de autenticação. No seu `ContentView.swift`, implemente o protocolo:

```swift
import SwiftUI
import AuthenticationSDK

struct ContentView: View, AuthenticationDelegate {
    @State private var userMessage: String = "Faça login"

    var body: some View {
        VStack(spacing: 20) {
            Text(userMessage)
                .font(.headline)
            
            Button("Login com Email/Senha") {
                AuthenticationManager.shared.delegate = self
                AuthenticationManager.shared.loginWithEmail(email: "email@teste.com", password: "123456")
            }
            .buttonStyle(.bordered)
            
            Button("Login com Google") {
                if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                    AuthenticationManager.shared.loginWithGoogle(presenting: rootVC)
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Login com Apple") {
                AuthenticationManager.shared.loginWithApple()
            }
            .buttonStyle(.bordered)
            
            Button("Logout") {
                AuthenticationManager.shared.logout()
                userMessage = "Deslogado"
            }
            .foregroundColor(.red)
        }
        .padding()
    }
    
    // MARK: - AuthenticationDelegate Methods
    func didAuthenticate(user: User?) {
        userMessage = "Bem-vindo, \(user?.email ?? "Usuário")"
    }

    func didFailWithError(_ error: Error) {
        userMessage = "Erro: \(error.localizedDescription)"
    }
}
```

### 2️⃣ Métodos de Autenticação

#### 🔹 **Login com Email/Senha (Firebase)**
```swift
AuthenticationManager.shared.loginWithEmail(email: "email@teste.com", password: "123456")
```

#### 🔹 **Login com Google**
```swift
if let rootVC = UIApplication.shared.windows.first?.rootViewController {
    AuthenticationManager.shared.loginWithGoogle(presenting: rootVC)
}
```

#### 🔹 **Login com Apple ID**
```swift
AuthenticationManager.shared.loginWithApple()
```

#### 🔹 **Logout**
```swift
AuthenticationManager.shared.logout()
```

## ✅ Contribuições
Contribuições são bem-vindas! Para melhorias e correções, faça um **Fork** e envie um **Pull Request**.

## 📜 Licença
Este projeto está licenciado sob a **MIT License**. Veja o arquivo `LICENSE` para mais detalhes.

## 📬 Contato
Caso tenha dúvidas ou sugestões, entre em contato via **seu-email@email.com**.

🚀 Desenvolvido por Victor Brigido

