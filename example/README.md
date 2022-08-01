# Roam Flutter SDK Example

Demonstrates how to use the roam_flutter plugin.

***NOTE***  
In the current release, location listener only works in foreground and background state. In order to receive locations in flutter side for terminated state, listener needs to be implemented with a flutter isolate or any background service library.

We are working on improving our flutter SDK to support listener for terminated state.

Locations can also be received (foreground/background/terminated) in project native modules, refer to our native Android and iOS SDK [Docs](https://docs.roam.ai).
