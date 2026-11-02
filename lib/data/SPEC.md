---
id: tikitaki-data
type: module-design
status: draft
title: Catalog and local persistence
parent: tikitaki-architecture
---

## Responsibility

Own the catalog wire contract and local persistence behind injectable repositories. Data is independent of navigation, widgets, and feature state; it must not reach into those layers. This boundary reflects current imports; its normative intent is unconfirmed pending review.

## Catalog contract

`GET {baseUrl}/api` accepts exactly status 200 and decodes an object with an `items` array. Each item requires string fields `url`, `name`, `collection`, and `thumbnail_url`; the last maps to `thumbnailUrl`. Media paths are relative to the configured server. Parsing uses strict casts, so malformed payloads fail rather than produce partial results. Non-200, network, and decoding errors propagate to the caller.

The repository returns the complete list in response order. It owns neither sorting policy nor UI error state. There is no pagination, explicit request timeout, automatic retry, or persisted catalog. API URL construction appends `/api` literally: a trailing slash in settings can produce a double slash. Media-path joining is a separate core concern.

## Persistence and identity

Settings use `base_url`, defaulting to `http://localhost:8080`. Storage does not validate or normalize addresses; the settings screen owns its current validation behavior.

Favorites use `favorite_urls`, a string list loaded into an in-memory set. Identity is the raw catalog `url`, not an absolute server-qualified address. Filtering preserves input catalog order. Unknown or removed catalog URLs remain stored but are invisible until a matching catalog item appears. Changing servers can therefore associate an old favorite with an unrelated matching path. **Unconfirmed rationale:** path-only identity may have assumed a single personal server; it is not a confirmed multi-server policy.

Toggle mutates memory before awaiting persistence and has no rollback on failure; the storage boolean result is not checked. Local persistence is implemented, but failure atomicity is not guaranteed.

## Evidence

Contracts are visible in `http_video_repository.dart`, `video_item.dart`, `api_response.dart`, and the SharedPreferences implementations; focused tests are under `test/data`. No schema migration or durable unique video identifier exists.
