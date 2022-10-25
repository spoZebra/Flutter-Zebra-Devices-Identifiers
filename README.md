# Flutter Zebra Device Identifiers

Starting with Android 10, Google restricted the way of accessing non-resettable identifiers such as SN, IMEI etc.

On Zebra devices we can still retrieve these values by using Zebra custom Content Provider together with EMDK.

Setup details can be found here: https://developer.zebra.com/blog/granting-permission-access-serial-imei-numbers-mobile-computers-running-a10

### More...
- Java: https://github.com/darryncampbell/OEMInfo-DeviceIdentifiers-Sample-Android
- Kotlin: https://github.com/ZebraDevs/oeminfo-test
