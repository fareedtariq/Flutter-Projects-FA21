<body>

  <h1>Campus Life Assistant App</h1>
  <p>This is a comprehensive Flutter-based application designed to assist students in managing their campus life efficiently. The app provides features like class schedule management, assignment tracking, event notifications, and more. It leverages Firebase and SQLite for data management and storage.</p>

  <h2>Features</h2>
  <ul>
    <li><strong>Firebase Setup</strong>: Integration with Firebase for authentication and notifications.</li>
    <li><strong>SQLite Setup</strong>: Implementation of offline storage using SQFlite for local data access.</li>
    <li><strong>Class Schedule Management</strong>: Add, view, and manage class schedules efficiently.</li>
    <li><strong>Firebase Authentication</strong>: Secure user authentication to ensure data privacy and personalized experience.</li>
    <li><strong>Event Notifications</strong>: Get notified about upcoming campus events via Firebase Cloud Messaging (FCM).</li>
    <li><strong>Assignment Tracker</strong>: Keep track of assignments and set deadline reminders.</li>
    <li><strong>Study Group Finder</strong>: Connect with peers to form study groups and collaborate on projects.</li>
    <li><strong>Feedback System</strong>: Provide feedback for continuous app improvement and better user experience.</li>
    <li><strong>UI Enhancements</strong>: Intuitive and user-friendly interface to ensure seamless navigation.</li>
    <li><strong>Testing & Documentation</strong>: Comprehensive testing and detailed documentation for better app reliability and developer collaboration.</li>
  </ul>

  <h2>Testing the App</h2>
  <p>Follow the steps below to test the app methods and functionalities:</p>
  <ol>
    <li><strong>User Authentication:</strong> Test Firebase authentication by signing up, logging in, and logging out.</li>
    <li><strong>Class Schedule:</strong> Add, edit, and delete class schedules. Ensure data syncs correctly with Firebase and SQLite.</li>
    <li><strong>Assignment Tracker:</strong> Create, view, and mark assignments as completed. Verify if the data updates in the local SQLite database.</li>
    <li><strong>Event Notifications:</strong> Check Firebase Cloud Messaging for event notifications and ensure the app displays them properly.</li>
    <li><strong>Feedback System:</strong> Submit feedback and confirm that it gets saved in the Firestore database.</li>
  </ol>
  <p>For advanced testing, consider integrating unit and widget tests for individual app components.</p>

  <h2>Setup Instructions</h2>
  <p>To run this app locally, follow these steps:</p>
  <ol>
    <li>Clone the repository:</li>
    <pre><code>git clone https://github.com/yourusername/campus_life_assistant_app.git</code></pre>
    <li>Navigate to the project directory:</li>
    <pre><code>cd campus_life_assistant_app</code></pre>
    <li>Install the dependencies:</li>
    <pre><code>flutter pub get</code></pre>
    <li>Run the app on your device or emulator:</li>
    <pre><code>flutter run</code></pre>
  </ol>

  <h2>How to Use the App</h2>
  <p>Follow these steps to get started with the Campus Life Assistant App:</p>
  <ol>
    <li><strong>Step 1:</strong> Open the app and sign in using Firebase authentication.</li>
    <li><strong>Step 2:</strong> Navigate to the 'Class Schedule' tab to add or view your class schedule.</li>
    <li><strong>Step 3:</strong> Use the 'Assignment Tracker' to create new assignments and set reminders.</li>
    <li><strong>Step 4:</strong> Set up event notifications under 'Event Notifications' to stay updated on campus events.</li>
    <li><strong>Step 5:</strong> Explore the 'Study Group Finder' to join or create study groups with fellow students.</li>
    <li><strong>Step 6:</strong> Provide feedback using the 'Feedback System' to help improve the app.</li>
  </ol>

  <h2>App Screenshots</h2>
  <p>Below are some screenshots of the app:</p>
  <div class="screenshot-section" style="display: flex; flex-wrap: wrap; gap: 20px;">
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Login Screen</h3>
      <img src="assets/login_screen.jpg" alt="Login Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Class Schedule</h3>
      <img src="assets/class_schedule.jpg" alt="Class Schedule" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Assignment Tracker</h3>
      <img src="assets/assignment_tracker.jpg" alt="Assignment Tracker" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Event Notifications</h3>
      <img src="assets/event_notifications.jpg" alt="Event Notifications" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Study Group Finder</h3>
      <img src="assets/study_group_finder.jpg" alt="Study Group Finder" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
    <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
      <h3>Feedback System</h3>
      <img src="assets/feedback_system.jpg" alt="Feedback System" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
    </div>
  </div>

  <h2>Dependencies</h2>
  <p>This app uses the following dependencies:</p>
  <ul>
    <li><b>firebase_auth</b>: Firebase authentication package for secure login.</li>
    <li><b>firebase_core</b>: Core Firebase functionality for Flutter.</li>
    <li><b>cloud_firestore</b>: Firestore database for real-time event and user data management.</li>
    <li><b>fluttertoast</b>: Custom toast notifications for user feedback.</li>
    <li><b>sqflite</b>: Local SQLite database for offline data storage and management.</li>
    <li><b>firebase_messaging</b>: Firebase Cloud Messaging for push notifications.</li>
  </ul>

  <h2>Contributing</h2>
  <p>If you'd like to contribute to this project, feel free to fork the repository and create a pull request. Ensure your changes align with the app’s functionality and design.</p>

  <h2>License</h2>
  <p>This project is licensed under the MIT License.</p>

</body>
