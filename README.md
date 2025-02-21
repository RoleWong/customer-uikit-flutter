
# **AI-powered Customer Service - Tencent Cloud Desk**

**Tencent Cloud Desk Customer UIKit** is a UIKit for integrating AI-powered customer service chat on the customer side of Tencent Cloud Desk, 
providing efficient and seamless communication with both AI and human agents.

## **Key Features**

- **Built for customer service** – Optimized UI, interactions, and workflows.
- **Quick integration** – Add a complete chat interface with just a few lines of code.
- **Customizable** – Supports global and session-level configurations.

## **Requirements**

### **Environment**

- **Flutter version**: 3.24 or later
- **Platform support**: Compatible with both emulators and physical devices

> **Note:** Flutter 3.24+ is recommended. If using an older version, consider integrating the IM UIKit with the customer service plugin instead.

### **Prerequisites**

Before integrating, complete the following steps:
1. Create a **Tencent Cloud Chat** application.
2. Enable the **Desk** feature.
3. Obtain a **Customer Service ID**.

For detailed setup instructions, refer to the [**Tencent Cloud Desk Quick Start Guide**](https://www.tencentcloud.com/document/product/1047/58964).

---  

## **Installation**

Install the `tencentcloud_ai_desk_customer` package via **pub**:

```bash
flutter pub add tencentcloud_ai_desk_customer
```

## **Usage**

### **1. Initialize the SDK**

Call `init` to initialize the SDK and configure global settings. Authentication requires [**Tencent Cloud Chat credentials (SDKAppID, userID, userSig)**](https://www.tencentcloud.com/document/product/1047/33517).

#### **Example**

```dart
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

TencentCloudAIDeskCustomer.init(
  sdkAppID: "SDKAppID",  // Your SDKAppID from the Tencent Cloud Chat Console
  userID: "userID",      // The authenticated user ID
  userSig: "userSig",    // The authentication signature
  config: TencentCloudCustomerConfig(), // Optional: Global configuration for customer service interactions
);
```

### **2. Launch the Customer Service Chat Interface**

Use `navigate` to open the customer service chat screen. Session-level configurations can be applied to override global settings.

#### **Example**

```dart
import 'package:tencentcloud_ai_desk_customer/tencentcloud_ai_desk_customer.dart';

TencentCloudAIDeskCustomer.navigate(
  context: context, // Flutter's BuildContext
  customerServiceID: "@customer_service_account", // The customer service account to connect with
  config: TencentCloudCustomerConfig(), // Optional: Session-specific configuration
);
```  

---  

## **Learn More**

For comprehensive documentation, visit the [**Tencent Cloud Desk Documentation**](https://www.tencentcloud.com/document/product/1047/63268).
