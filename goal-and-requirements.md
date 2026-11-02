---
id: tikitaki-goals
type: goal-and-requirements
status: draft
title: TikiTaki product requirements
---

## Goal and audience

TikiTaki is a personal short-video viewer for a self-hosted media library: the familiar vertical-swipe experience without a social network. The owner supplies a server; the app browses its catalog and streams its media. iOS is the primary target, with a Flutter cross-platform codebase.

## Capabilities

- Browse the catalog, collections, and locally saved favorites in three-column thumbnail galleries.
- Open a gallery item into fullscreen playback, with a fixed queue drawn from that gallery's displayed order. Swipe vertically within that context; autoplay, looping, tap-to-pause, progress, long-press scrubbing, and favorite toggling support viewing.
- Group videos by the server's collection field, using the first member as a preview. Offer optional name sorting for collections and filenames within a collection.
- Preserve API order in History. **Unconfirmed reconciliation:** this follows implementation, its regression test, and commit `4cf2565`, rather than the collection-name sorting in the older requirements. The inferred reason is to respect server-curated ordering; that rationale has not been confirmed.
- Persist a configurable server address and favorite selections locally. Settings application and identity limitations belong to their module specs.
- Reload the catalog from History using pull-to-refresh or error retry.

## Scope and principles

The README and older requirements exclude accounts, tracking, cloud services, search/filter, and offline library playback. The catalog arrives in one response without pagination. Thumbnail caching is a performance aid, not an offline library feature; the older phrase “no caching” must not be read as prohibiting thumbnails.

Dark presentation is the current default and enforced app theme. Smooth 60fps gallery scrolling and responsiveness are requirements from the source document, not measured guarantees.

## Source status and discrepancies

This draft is inferred from the implementation, tests, README, and `docs/REQUIREMENTS.md`; the user declined the clarification round. No existing document was adopted into the graph or edited. `docs/REQUIREMENTS.md` remains historical input, and `docs/PLAN.md` remains an implementation plan, not a spec node. **Unconfirmed:** this graph is proposed as the current requirements record pending user review, not evidence that the older decisions were approved for replacement.

The source requirement for pull-to-refresh on every gallery remains an unmet requirement: only History currently wires it. Other observed implementation gaps are recorded at their owning boundaries rather than promoted into intentional product restrictions.
