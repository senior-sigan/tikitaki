---
id: tikitaki-architecture
type: architecture-design
status: draft
title: Application architecture
parent: tikitaki-goals
---

## Topology

A single Flutter client consumes an externally hosted catalog and media server. `main.dart` is the composition root: it loads SharedPreferences and the base URL, constructs repositories and shared view models, starts catalog loading, then mounts the app. The server is outside this repository's application boundary.

`lib/data` owns transport, models, and local persistence (`tikitaki-data`). `lib/core` owns navigation and shared presentation (`tikitaki-core`). `lib/features` owns screen behavior and observable application state. Media decoding/playback is delegated to the `video_player` plugin; thumbnails use `cached_network_image`.

## Dependency structure

The actual graph is not strict three-layer architecture:

- Data imports neither core nor features.
- Feature screens use core presentation and route payloads; core's router imports feature screens and view models. This is a deliberate description of a current import cycle, not an acyclic layering guarantee.
- The catalog owner lives in History. Collections and Favorites consume that shared owner instead of fetching independent catalogs. Player consumes Favorites for likes. These feature edges are specified by the feature parent spec.
- The composition root supplies concrete repositories through constructors; view models depend on repository interfaces where provided.

Native `ChangeNotifier`/`ValueNotifier`, manual injection, and GoRouter follow `.claude/rules/FLUTTER.md`; no third-party state-management container or separate domain package exists. **Unconfirmed rationale:** these choices keep this small client simple. Agent guidelines describe ideals as well as implemented conventions: manual JSON decoding and forced dark mode, for example, differ from their generic JSON-generator and system-theme advice.

## Runtime and ownership

One base URL snapshot is distributed to the HTTP repository and routed screens at startup. The catalog is app-scoped; queues are route-scoped snapshots. Preferences persist only settings and favorite identities, not a downloaded catalog or media library.

Widgets own local controllers and view models expose explicit disposal where implemented. Production wiring does not explicitly close the root HTTP client, root view models, router, or route-created PlayerViewModel. This is an observed ownership gap, not a guarantee of complete lifecycle cleanup.

## Evidence and status

This architecture is inferred from `lib/main.dart`, `lib/app.dart`, router imports, repositories, and feature view models. All nodes remain draft pending user review. Unit/widget tests cover these components, but do not establish real-device playback lifecycle or performance targets.
