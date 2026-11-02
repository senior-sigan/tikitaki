---
id: tikitaki-player
type: submodule-design
status: draft
title: Contextual video playback
parent: tikitaki-features
depends-on: [tikitaki-data, tikitaki-core]
---

## Responsibility and boundary

Own contextual queue navigation and media-controller presentation, not catalog fetching or storage. The feature parent `tikitaki-features` owns cross-feature dependency edges. `PlayerViewModel` owns queue/index state; `VideoPage` owns each mounted page's plugin controller. `PlayerScreen` owns the page controller and shared progress notifier.

## Queue contract

Copy the supplied list into an unmodifiable snapshot and begin at the supplied index. The source gallery determines both membership and order. Navigation stops at the ends rather than wrapping; invalid jump requests are ignored. The constructor assumes a nonempty list and valid start index without validating them.

Refreshing the catalog or removing a favorite does not rewrite an open queue. **Unconfirmed rationale:** a snapshot keeps swiping stable while the underlying library or favorites change. This is observed behavior, not user-confirmed product intent.

## Playback behavior

Each mounted video page creates a network controller, initializes it, enables looping, and starts playback. Tap toggles pause/play. A long-press horizontal scrub pauses, seeks relative to its starting position by a fraction of total duration, clamps to the clip bounds, then resumes playback—even if playback had previously been paused. The player also shows progress, back/like controls, and a next-thumbnail preview during forward drag.

Initialization failure displays an error icon. Page disposal removes the controller listener and disposes the controller. Screen disposal releases its page controller and progress notifier; broader app/view-model ownership gaps belong to `tikitaki-architecture`.

## Lifecycle and correctness limitations

The code does not coordinate exclusive active-page playback: each mounted page autoplays and writes to the same progress notifier. Asynchronous initialization may continue through loop/play after a page is disposed because its mounted check occurs afterward. Background/route visibility has no explicit app-level playback policy. These are observed risks, not verified device-level failures or guarantees of correct lifecycle handling.

The like overlay listens to Favorites notifications, not queue-index notifications. A swipe therefore does not directly refresh its captured video target; the icon/toggle may remain associated with the previous video until another rebuild. This is an inspection finding requiring a targeted regression test, not an intentional behavior contract.

**Unconfirmed:** these gaps are recorded as limitations pending user review, not accepted product restrictions. No fixes are part of spec onboarding.

## Evidence

`player_view_model.dart` and its tests establish snapshot/bounds behavior. `video_page.dart` and `player_screen.dart` establish controller ownership and listeners. Current widget tests and the fake player platform do not establish controller exclusivity, safe asynchronous disposal, or swipe-to-like correctness; real-device playback and performance have not been verified by this documentation work.
