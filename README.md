# ADHD Helper App

## Overview
ADHD Helper is a mobile application designed to assist individuals with ADHD in managing their daily routines more effectively. It provides features like task organization, focus timers, and a **custom-time water reminder** to ensure users stay hydrated throughout the day.

## Features
- **Task Manager** – Create, organize, and track daily tasks with notifications, leveraging **Hive/Isar** for efficient local storage.
- **Focus Mode** – A Pomodoro-style timer built using Flutter's **ticker provider** to help users stay productive.
- **Custom Water Reminder** – Uses **Flutter Local Notifications** and **WorkManager** for persistent background alerts.


## Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Database**: Hive, SQLite
- **Notifications & Background Services**:
  - **Flutter Local Notifications** (for scheduled alerts)
  - **WorkManager** (for persistent reminders even when the app is closed)
  - **Android AlarmManager** for periodic tasks
- **Navigation**: GoRouter
- **Dependency Injection**: get_it (optional, if needed later)
- **Crash Reporting & Analytics**: Firebase Crashlytics & Google Analytics (optional, if needed later)

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/adhd-helper.git
   ```
2. Navigate to the project directory:
   ```sh
   cd adhd-helper
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Run the app:
   ```sh
   flutter run
   ```

## Custom Water Reminder Setup
1. Open the app and navigate to the "Water Reminder" section.
2. Choose your preferred time for reminders.
3. Save the settings; the app will schedule notifications using **Flutter Local Notifications + WorkManager**.
4. The background service ensures reminders persist even after the app is terminated.

## Contributing
Pull requests are welcome! Please follow the existing coding standards and keep the project structure maintainable.

## License
MIT License. See `LICENSE` for details.

---


For any queries, reach out to me at https://www.linkedin.com/in/supratimdhara/.

