## 1.2.0 & 1.2.0+1

## Breaking Changes

- Renamed package from `tencent_cloud_customer` to `tencentcloud_ai_desk_customer`.
- Renamed class from `TencentCloudCustomer` to `TencentCloudAIDeskCustomer`.

## Added

- Added support for the Indonesian language.
- Introduced a `language` option in `TencentCloudCustomerConfig` for explicit language selection.

## Fixed

- Fixed a bug in streamed messages causing inconsistent real-time output.

# 1.1.0

## Added

- Introduced `dispose` method to properly clean up resources before logging out or switching accounts.

# 1.0.0

First release of the Customer Service UIKit.

## Initial Release

- Added `init` method to initialize the Customer UIKit.
- Added `navigate` method to open the customer service chat interface.
