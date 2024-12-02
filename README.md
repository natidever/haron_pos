# Haron POS 🏪

<p align="center">
  <img src="assets/icon/logo.png" alt="Haron POS Logo" width="200"/>
</p>

A modern Point of Sale (POS) system built with Flutter, featuring a clean UI, offline-first architecture, and comprehensive business management tools.

## ✨ Features

- 📱 Beautiful Material Design UI with Dark Mode support
- 💳 Multiple payment method support
- 📊 Real-time sales analytics and reporting
- 🏷️ Product management with categories
- 📝 Transaction history and tracking
- 🔄 Offline-first architecture using Hive DB
- 🖨️ Receipt generation and printing
- 🌙 Dark/Light theme support
- 📱 Responsive design for all screen sizes

## 🛠️ Built With

- [Flutter](https://flutter.dev/) - UI Framework
- [Flutter Bloc](https://bloclibrary.dev/) - State Management
- [Hive](https://docs.hivedb.dev/) - Local Database
- [Hydrated Bloc](https://pub.dev/packages/hydrated_bloc) - Persistent State Management
- [PDF](https://pub.dev/packages/pdf) - PDF Generation
- [Google Fonts](https://pub.dev/packages/google_fonts) - Typography
- [Syncfusion Flutter DataGrid](https://pub.dev/packages/syncfusion_flutter_datagrid) - Data Tables

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.4.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
2. Navigate to project directory
3. Install dependencies(run pub get )
4. Run the app


## 📱 Screenshots



## 🏗️ Project Structure
lib/
├── bloc/ # Bloc state management
├── models/ # Data models
├── pages/ # UI screens
├── widgets/ # Reusable widgets
├── constants/ # App constants
├── theme/ # Theme configuration
├── utils/ # Utility functions
└── main.dart # App entry point



## 🔄 State Management

The app uses Flutter Bloc for state management with the following structure:

- **Cart Bloc**: Manages shopping cart state
- **Products Bloc**: Handles product inventory
- **Theme Bloc**: Controls app theme
- **Transaction Bloc**: Manages sales transactions

## 💾 Local Storage

Hive DB is used for local storage with the following boxes:

- **products**: Store product inventory
- **transactions**: Store sales records
- **settings**: App configuration
- **userBox**: User data

## 🛣️ Roadmap

- [ ] Barcode scanner integration
- [ ] Cloud backup/sync
- [ ] Multiple user roles
- [ ] Inventory alerts
- [ ] Customer management
- [ ] Supplier management

## 🤝 Contributing

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## 👨‍💻 Author

**Natnael Sisay**

- Github: [@natidever](https://github.com/natidever)

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/)
- [Bloc Library](https://bloclibrary.dev/)
- [Hive Database](https://docs.hivedb.dev/)

---

<p align="center">
  Made with ❤️ by Natnael Sisay
</p>

