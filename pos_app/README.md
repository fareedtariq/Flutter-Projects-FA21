<body>

  <h1>POS App - Point of Sale System using Flutter</h1>
  <p>This is a Flutter-based POS (Point of Sale) application that enables businesses to manage sales, inventory, and customer data. The app supports multiple devices and integrates with a local database for smooth transaction processing. Features include order management, inventory tracking, and payment processing.</p>

  <h2>Features</h2>
  <ul>
    <li><strong>Product Management</strong>: Add, update, and delete products. Track product details such as price, quantity, and description.</li>
    <li><strong>Home Screen</strong>: A dashboard that displays key business metrics, recent transactions, and quick links to common actions.</li>
    <li><strong>Authentication</strong>: User login with Firebase authentication, ensuring secure access to the app.</li>
    <li><strong>Transaction Management</strong>: Process sales transactions, generate receipts, and handle payments including cash, credit card, and digital wallets.</li>
    <li><strong>Account Management</strong>: User account creation and management. Admins can control permissions and access levels for different users.</li>
    <li><strong>Stock Reports</strong>: Generate detailed stock reports and export them as PDF files. Monitor product inventory levels and trends.</li>
    <li><strong>Payment Processing</strong>: Supports multiple payment methods including cash, credit card, and digital wallets.</li>
    <li><strong>Sales Reporting</strong>: Generate detailed sales reports to track business performance and export them as PDF files.</li>
    <li><strong>User Authentication</strong>: Secure login for administrators and staff with Firebase authentication.</li>
    <li><strong>Multi-device Support</strong>: Optimized for both Android and iOS platforms.</li>
  </ul>

  <h2>Setup Instructions</h2>
  <p>To run this app locally, follow these steps:</p>
  <ol>
    <li>Clone the repository:</li>
    <pre><code>git clone https://github.com/fareedtariq/pos_app.git</code></pre>
    <li>Navigate to the project directory:</li>
    <pre><code>cd pos_app</code></pre>
    <li>Install the dependencies:</li>
    <pre><code>flutter pub get</code></pre>
    <li>Run the app on your device or emulator:</li>
    <pre><code>flutter run</code></pre>
  </ol>

  <h2>App Screenshots</h2>
 <p>Below are some screenshots of the app:</p>

<div class="screenshot-section" style="display: flex; flex-wrap: wrap; gap: 20px;">
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Splash Screen</h3>
    <img src="assets/splash_screen.jpg" alt="Splash Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Login Screen</h3>
    <img src="assets/login_screen.jpg" alt="Login Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Notification</h3>
    <img src="assets/notification_screen.jpg" alt="Notification" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Setup Profile</h3>
    <img src="assets/Setup_profile.jpg" alt="Setup Profile" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Home Screen</h3>
    <img src="assets/home_screen.jpg" alt="Home Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
  <div class="screenshot-section" style="display: flex; flex-wrap: wrap; gap: 20px;">
  <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Products Screen</h3>
    <img src="assets/products_screen.jpg" alt="Products Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
     <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Account Screen</h3>
    <img src="assets/accounts_screen.jpg" alt="Account Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
 <div class="screenshot" style="flex: 1 1 calc(33.33% - 20px);">
    <h3>Stock Report Screen</h3>
    <img src="assets/stock_reposts.jpg" alt="Stock Report Screen" style="width: 20%; border-radius: 10px; box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);">
  </div>
</div>

  

  <h2>Dependencies</h2>
  <p>This app uses the following dependencies:</p>
  <ul>
    <li><b>firebase_auth</b>: Firebase authentication package.</li>
    <li><b>firebase_core</b>: Core Firebase functionality for Flutter.</li>
    <li><b>cloud_firestore</b>: Firestore database integration for storing transaction data.</li>
    <li><b>fluttertoast</b>: Custom toast notifications for user feedback.</li>
    <li><b>sqflite</b>: Local SQLite database for storing product inventory and orders (if applicable).</li>
    <li><b>pdf</b>: Library to generate and export reports in PDF format.</li>
  </ul>

  <h2>Contributing</h2>
  <p>If you'd like to contribute to this project, feel free to fork the repository and create a pull request. Ensure your changes align with the app’s functionality and design.</p>

  <h2>License</h2>
  <p>This project is licensed under the MIT License.</p>

</body>
