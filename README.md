# books_bart

The software helps to improve the quality of customer service and avoid difficulties in the work of managers. It also facilitates customer interaction with the store by reducing the number of steps between viewing a product and ordering it. The mobile application allows you to display up-to-date information on the characteristics of a particular product and its availability in the store.

<img width="134" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/72474bee-2046-44b9-ad4e-7a296c8c86a3">
<img width="132" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/5065b3df-d105-4744-bdd7-b16c974437a2">
<img width="132" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/8fc3c4a6-1bd8-4d5c-b2e6-3e0f89420085">
<img width="132" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/44bfc9f5-fe35-4354-ac3b-f0e7b59e9249">
<img width="132" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/00de7a56-0243-41a7-ae47-a3bfefe4cbb0">
<img width="132" alt="image" src="https://github.com/Grifon333/books_bart/assets/86651927/b54478c6-937a-4aee-9bb3-7cc04b873759">

## Features

- Flutter/Dart
- MVVM and BLoC/Cubit architecture;
- Firebase (Firebase Auth, Firebase Firestore, Firebase Storage);
- Shared Preferences and Secure Storage;
- DI and Servise Locator;
- Provider

## Getting Started

### Firebase

1. Create your project
2. Enable desired authentication options

### iOS

1. Replace `./ios/Runner/GoogleService-Info.plist` with your own
2. Update `./ios/Runner/info.plist`
   - Paste the `REVERSED_CLIENT_ID` from `GoogleService-Info.plist` to key `CFBundleURLSchemes` in `info.plist`

### Android

1. Replace `./android/app/google-services.json` with your own
2. Update `./android/app/build.gradle`
   - Replace `"com.example.flutter_firebase_login"` with the `package_name` from `google-services.json`

### Run the project

1. `flutter run`
