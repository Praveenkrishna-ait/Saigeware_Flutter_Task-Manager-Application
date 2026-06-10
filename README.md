Task Manager Application - Flutter & Hive

A premium, highly interactive Task Management application built with Flutter, designed specifically to deliver a fluid, native-like experience on Web and Desktop. 

Gravity Task Manager transcends standard UI/UX by employing a custom "Deep Space" design system, featuring physics-based animations, magnetic cursor interactions, and highly optimized rendering to ensure 60fps performance across all devices.


Key Features

Premium "Deep Space" Aesthetics
*   Vibrant Dark Mode: A stunning color palette utilizing deep cosmic blues (`#070A14`) accented with neon primary colors (`#7C6BFF` Violet, `#00F5D4` Teal).
*   Solid Glassmorphism: Optimized for Flutter Web to deliver the feel of frosted glass without the heavy rendering tax of `BackdropFilter` inside slivers.
*   Modern Typography: Clean, highly legible interface using the Google Fonts Inter typeface.

Physics-Based Interactions
*   Gravity Drop-in Animations: Task cards elegantly fall into place using staggered `TweenAnimationBuilder` effects.
*   Magnetic Dashboard: Summary cards feature 3D matrix-tilt effects that physically react to cursor movement and provide dynamic spotlight reflections.
*   Spring Dynamics: Form elements and buttons utilize `easeOutBack` curves to realistically bounce and scale when hovered or pressed.
*   Cursor Spotlight (Gravity Dot): A large, glowing neon orb smoothly tracks the user's cursor across the background, providing dynamic ambient lighting.

Robust Architecture
*   State Management: Powered by the lightweight and scalable Provider package.
*   Local Persistence: Lightning-fast, offline-first data storage powered by Hive NoSQL database.
*   Clean Architecture: Strict separation of concerns (Domain Models, Providers, UI Themes, and View layers) for easy maintenance and scaling.

Task Management Core
*   Full CRUD Operations: Create, Read, Update, and Delete tasks instantly.
*   Priority System: Visually distinct priority pills (Low, Medium, High) with neon glowing indicators.
*   Due Dates & Scheduling: Integrated date picker with smart timeline coloring (overdue tasks turn red, upcoming turn yellow).
*   Quick Actions: Swipe-to-delete dismissible tasks and one-tap completion toggles.

---

Getting Started

 Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
*   A modern web browser (Google Chrome recommended)

 Installation & Running

1. Clone the repository (if applicable) and navigate to the project directory:
   bash
   cd "Task Manager Application/task_manager"
   

2. Install dependencies:
   bash
   flutter pub get
   

3. Run on Web (with persistent data):
   To ensure your Hive database saves across debug sessions, run using a custom Chrome data directory:
   bash
   flutter run -d chrome --web-browser-flag="--user-data-dir=C:\tmp\flutter_chrome_data"


Project Structure

text
lib/
├── core/
│   ├── theme/          # Custom AppTheme, Dark Palette, Glassmorphism helpers
│   └── utils/          # Date & String extension methods
├── domain/
│   └── entities/       # Hive Task models and Priority Enums
├── presentation/
│   ├── providers/      # TaskListProvider (State & Hive logic)
│   ├── screens/        # Dashboard, Add/Edit Task Form
│   └── widgets/        # Custom Cards, Bouncing Buttons, Gravity Orbs
└── main.dart           # App entry point, Hive Initialization

Built With
  [Flutter](https://flutter.dev/) - UI Toolkit
  [Hive](https://docs.hivedb.dev/) - Lightweight & blazing fast local database
  [Provider](https://pub.dev/packages/provider) - State Management
  [Google Fonts](https://pub.dev/packages/google_fonts) - Dynamic typography
  [Intl](https://pub.dev/packages/intl) - Date formatting

 Dashboard Image: <img width="1906" height="914" alt="image" src="https://github.com/user-attachments/assets/4ec9174b-5b45-488a-b27a-856a4131880e" />

 Add New Task Image: <img width="1886" height="827" alt="image" src="https://github.com/user-attachments/assets/b39e9d50-04d7-48de-8c92-c6011a52e183" />

 Completed Task List Image: <img width="1913" height="747" alt="image" src="https://github.com/user-attachments/assets/303c99a5-52ef-4adf-b05e-838d353cd6c7" />

 Pending Task List Image: <img width="1903" height="902" alt="image" src="https://github.com/user-attachments/assets/8ba97d8a-1636-4eaf-a32a-c8d15e560607" />




