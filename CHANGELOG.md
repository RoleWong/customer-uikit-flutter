# 1.2.4

## Fixed

- Fixed some bugs.

# 1.2.3

## Fixed

- Resolved an issue where a new conversation would automatically start after the previous session ended.

## Optimized

- Improved the layout of evaluation messages.
- Improved the layout for quoted messages within the Workspace display.

# 1.2.2

## Added

- Added a new animated loading indicator for the bot’s "thinking" state.

# 1.2.1

## Fixed

- Addressed build failures on Flutter 3.27.1.
- Resolved video playback and recording issues on Huawei P30.

## Optimized

- Refined the UI for group notification display.
- Improved the layout of the read receipt page.
- Enhanced text wrapping and truncation for lengthy tip messages.

# 1.2.0

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
