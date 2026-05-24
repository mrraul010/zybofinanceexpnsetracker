Zybo Expense Tracker
Hey there! Welcome to the repository for my Proactive Expense Manager app, built for the Zybo Flutter Technical Challenge.

This isn't just a basic CRUD app. I designed it to be a true offline-first, hybrid local/cloud experience. It leverages a local SQLite database for instant UI updates and a dedicated background engine to carefully synchronize relational data with a remote backend.



What's Inside
 Offline-First & Lightning Fast: You shouldn't need Wi-Fi to log a cup of coffee. Every transaction and category is saved locally first. The UI updates instantly, and the data waits safely until you're ready to back it up.

 Enterprise-Grade Sync Engine: This was the most complex and fun part to build. Instead of a messy bulk upload, the app uses a strict, 4-step relational sync protocol. It safely purges soft-deleted items, uploads new categories, and then uploads transactions to completely avoid foreign-key clashes on the server.

 Proactive Budget Alerts: Nobody wants to find out they broke their budget after they open the app. I built a local tracker that evaluates your current month's expenses and fires a native push notification the exact second a new transaction pushes you over your custom limit.

 Clean Architecture & BLoC: The UI is completely decoupled from the data layer. flutter_bloc handles the state reactivity (including active sync animations), while custom dio interceptors automatically inject auth tokens into every API call behind the scenes.

 Local Identity: Every item gets a UUID generated right on the device at the moment of creation, ensuring global uniqueness across local and cloud databases.


 🛠️ The Tech Stack
Framework: Flutter (Dart)

State Management: flutter_bloc + equatable

Local Storage: sqflite (Relational schema with custom SQL joins)

Network & API: dio (configured with auth interceptors)

Dependency Injection: get_it

Notifications: flutter_local_notifications

Utilities: uuid, shared_preferences


How the Cloud Sync Actually Works (Phase 3.2)
Handling offline data means dealing with "Soft Deletes" and relational integrity. I built a dedicated SyncBloc to handle the heavy lifting when you tap the "Sync to Cloud" button. Here is the exact pipeline:

Cloud Purge (Transactions then Categories): It finds all locally deleted items (is_deleted = 1) and sends their UUIDs to the server's delete endpoint. Only when the API returns a 200 OK success does the app perform a permanent hard delete in the local SQLite database.

Categories First: Unsynced categories (is_synced = 0) are individually pushed to the server first. This ensures that the relational structure exists on the backend before any transactions arrive.

Transactions Batching: Finally, unsynced transactions are formatted to match the exact JSON array contract required by the API and batch-uploaded.

Verification: Local rows are finally flagged as is_synced = 1 only after the server confirms receipt.


Getting Started
To get this project up and running on your local machine:

1. Clone the repository:



git clone 
cd zyboexpensetracker


2. Install dependencies:
flutter pub get

3. Run the application:
flutter run

Note: If testing on Android 13+, the app will gracefully request Notification permissions on launch so the budget alerts can fire


Built by P Rahul Raj