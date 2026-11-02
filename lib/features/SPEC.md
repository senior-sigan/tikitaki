---
id: tikitaki-features
type: module-design
status: draft
title: Catalog browsing and application state
parent: tikitaki-architecture
depends-on: [tikitaki-data, tikitaki-core]
---

## Responsibility and boundary

Own catalog loading state, gallery projections, favorite interaction, and server-setting UI. Screens use injected state and repositories, not direct HTTP or preference access. Shared presentation and routing belong to `tikitaki-core`; wire formats and storage identities belong to `tikitaki-data`. Playback is a separate controller-lifecycle boundary in `tikitaki-player`.

These contracts describe current code, with inferred intent unconfirmed pending review. The closely coupled gallery directories are documented together because they project one catalog rather than own separate data sources.

## Feature dependency edges

History's `VideoListViewModel` is the shared catalog authority despite its directory name: it is not viewing history or a record of watched videos. Collections and Favorites observe it. Player depends on Favorites for likes; gallery screens pass their displayed lists and indices through the core route payload. Settings uses only the settings repository and does not replace running catalog dependencies.

## Catalog state and projections

Catalog load transitions from initial/loaded/error through loading to loaded or error; a load already in flight suppresses concurrent requests. Failure preserves the old list in memory. Refresh is another load, not an incremental merge. Ordering policy is recorded in `tikitaki-goals`.

Collections groups by exact collection string, retaining first-occurrence group order and member order. The first member supplies the preview. Optional case-insensitive name sorting affects collection previews only. Detail screens independently toggle case-insensitive filename sorting without mutating the underlying group. Sort choices are not persisted; the UI label “Sorted by date” means API order, not a local timestamp sort.

Favorites derives its displayed list from the current catalog and the persistence repository; toggling awaits that repository before notifying listeners. Both derived view models react to catalog `loaded` notifications, not loading/error notifications, and remove their source listeners on disposal.

## Presentation and failure gaps

History shows loading, the gallery, or error with retry; refresh replaces its gallery with loading presentation. Collections, detail, and Favorites instead show projected or empty content without exposing catalog error/loading state, so they can retain old content after refresh failure. The all-gallery refresh requirement and its missing wiring are recorded in `tikitaki-goals`. History's grid does not force always-scrollable physics, so short/empty-list pull-to-refresh is not guaranteed.

These are observed limitations, not intentional permanent exclusions; their product status is unconfirmed.

## Server settings

The screen reads the saved address and saves text only when URI parsing finds a scheme. It does not require HTTP(S), a host, trimming, or endpoint normalization. Save errors have no explicit UI recovery. Saving shows a restart-required message; the startup snapshot described in `tikitaki-architecture` remains unchanged in the running app. **Unconfirmed rationale:** restart-only application avoids rebuilding the dependency graph; this is documented as a current limitation rather than a permanent requirement.

## Evidence

See the History, Collections, Favorites view models and their screens, plus `settings/settings_screen.dart`. Tests under `test/features` cover projection, ordering, states, and settings feedback; the presence of a refresh widget alone is not proof that every gallery can refresh.
