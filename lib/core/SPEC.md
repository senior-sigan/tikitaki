---
id: tikitaki-core
type: module-design
status: draft
title: Navigation and shared presentation
parent: tikitaki-architecture
depends-on: [tikitaki-data, tikitaki-features, tikitaki-player]
---

## Responsibility

Own the navigation shell, route composition, common gallery presentation, theme, and media-path joining. Routing is the integration surface; it may construct feature screens but does not fetch catalogs or persist favorites. Shared widgets accept data and callbacks rather than own application state. These observed boundaries are proposed contracts, unconfirmed pending review.

## Navigation contract

GoRouter uses an indexed-stack shell with History (`/`), Collections (`/collections` with `:name` detail), Favorites (`/favorites`), and Settings (`/settings`). The floating icon toolbar switches branches while keeping their navigation state. `/player` is outside the shell so playback has no gallery toolbar.

Player navigation carries an in-memory `PlayerRouteData` list and start index. Opening `/player` without that payload shows “No video data provided”; the URL alone is not a restorable playback deep link. Valid nonempty lists and in-range indices are caller preconditions, not route-level validation.

## Shared presentation

The app uses dark Material 3 styling. The shared video grid is a lazy three-column gallery; thumbnail widgets provide cached network images with loading/error presentation. Collection previews use their own grid. Refresh and load/error states belong to screens, not the shared grid.

Media URL joining strips one trailing slash from the base and adds a separator when the media path lacks one. It is string joining, not general URI resolution: callers supply relative media paths, not arbitrary absolute URLs. Catalog endpoint construction is owned by `tikitaki-data`.

## Evidence

See `app_router.dart`, `navigation_shell.dart`, `app_theme.dart`, `url_utils.dart`, and `widgets/`; focused widget and utility tests are under `test/core`. Cross-boundary import cycles are recorded once in `tikitaki-architecture`, rather than hidden behind a claim that all core code is feature-independent.
