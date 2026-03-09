# TikiTaki — Requirements Specification

## Overview

Personal short vertical video viewer app. Instagram/TikTok-style UI for browsing a self-hosted video library.

**Platform**: iOS (primary), Flutter cross-platform
**Theme**: Dark by default

## Data Source

- **API**: `GET {baseUrl}/api` returns `{ "items": [...] }`
- **Base URL**: Configurable via settings screen (default: `http://localhost:8080`)
- **Video item schema**:
  ```json
  {
    "url": "/media/cats/20260101.mp4",
    "name": "20260101.mp4",
    "collection": "cats",
    "thumbnail_url": "/media/.thumbnails/cats/20260101.jpg"
  }
  ```
- Media URLs (url, thumbnail_url) are relative to baseUrl

## Navigation

Bottom navigation bar with 4 tabs:
1. **History** (all videos)
2. **Collections**
3. **Favorites**
4. **Settings**

## Screens

### S1: History (All Videos)

- Grid gallery: 3 columns, infinite scroll
- Each cell: video thumbnail from `thumbnail_url`
- Sorted by collection name
- Tap on video -> Video Player (swipe context: all videos)

### S2: Collections

- Grid gallery: 3 columns
- Each cell: collection preview (thumbnail of the first video in collection)
- Collection name displayed on/under the cell
- Tap on collection -> Collection Detail screen

### S3: Collection Detail

- Grid gallery: 3 columns, showing all videos of the selected collection
- Header/title with collection name
- Tap on video -> Video Player (swipe context: videos of this collection)

### S4: Favorites

- Grid gallery: 3 columns
- Shows videos marked as liked
- Stored locally (no API, local persistence)
- Tap on video -> Video Player (swipe context: favorite videos only)

### S5: Video Player

- Fullscreen vertical video player
- **Autoplay**: video starts automatically on open
- **Loop**: video loops until user swipes or exits
- **Swipe up/down**: navigate to next/previous video within the context list:
  - Opened from History -> swipe through all videos
  - Opened from Collection Detail -> swipe through collection videos
  - Opened from Favorites -> swipe through favorites
- **Like button**: toggle favorite status, persisted locally
- **Back button**: return to previous screen
- **Progress bar**: thin progress indicator at the bottom
- Tap to pause/play

### S6: Settings (4th tab in bottom nav)

- Configure server base URL
- Minimal screen

## Functional Requirements

| ID | Requirement |
|----|-------------|
| FR-01 | App fetches video list from `{baseUrl}/api` on launch |
| FR-02 | Videos displayed as thumbnail grid (3 columns) on History, Collection Detail, and Favorites screens |
| FR-03 | Tapping a thumbnail opens fullscreen video player |
| FR-04 | Video player supports vertical swipe to navigate prev/next video |
| FR-05 | Swipe navigation respects the source context (all videos / collection / favorites) |
| FR-06 | Like button in player toggles favorite status |
| FR-07 | Favorites stored locally on device (SharedPreferences or similar) |
| FR-08 | Collections tab groups videos by `collection` field |
| FR-09 | Collection preview uses thumbnail of the first video |
| FR-10 | Tapping a collection opens a detail grid of that collection's videos |
| FR-11 | Base URL is configurable via settings screen |
| FR-12 | Videos in History sorted by collection name |
| FR-13 | Video autoplay and loop in player |
| FR-14 | Pull-to-refresh on gallery screens to reload data from API |
| FR-15 | Progress bar at the bottom of video player |
| FR-16 | API returns all items at once, no pagination needed |
| FR-17 | No search/filter functionality |
| FR-18 | Online-only, no offline caching |

## Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| NFR-01 | Dark theme by default |
| NFR-02 | Target platform: iOS (primary) |
| NFR-03 | Smooth 60fps scrolling in grids |
| NFR-04 | Thumbnail caching for performance |
| NFR-05 | Responsive to different screen sizes |

## Resolved Decisions

| Question | Decision |
|----------|----------|
| Pagination | API returns all items at once |
| Offline mode | Online-only, no caching |
| Pull-to-refresh | Yes, on all gallery screens |
| Player controls | Tap pause/play + progress bar + like button |
| Search/filter | Not needed |
| Swipe context | Contextual (favorites -> favorites, collection -> collection) |
| Collection tap | Opens collection detail gallery |
| Settings access | 4th tab in bottom navigation |
| Theme | Dark by default |
| Platform | iOS primary |
| Base URL | Configurable via Settings tab |
| Player behavior | Autoplay + loop |
