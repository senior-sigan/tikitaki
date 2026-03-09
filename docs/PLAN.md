# TikiTaki — Plan

TDD-подход: RED (пишем падающий тест) -> GREEN (минимальный код чтобы тест прошёл) -> REFACTOR.

Задачи сгруппированы по фазам. Внутри фазы — порядок выполнения сверху вниз.

---

## Phase 0: Project Setup

### 0.1 Зависимости и конфигурация
- [ ] Добавить зависимости: `go_router`, `http`, `shared_preferences`, `cached_network_image`, `video_player`
- [ ] Добавить dev-зависимости: `checks`, `mocktail`
- [ ] Настроить `analysis_options.yaml` с `flutter_lints`
- [ ] Удалить шаблонный код из `lib/main.dart`

### 0.2 Структура проекта
- [ ] Создать структуру каталогов:
  ```
  lib/
    core/          # constants, theme, router
    data/          # models, api client, repositories
    features/
      history/     # all videos grid
      collections/ # collections grid + detail
      favorites/   # favorites grid
      player/      # fullscreen video player
      settings/    # base URL config
    app.dart       # MaterialApp root widget
  ```

---

## Phase 1: Data Layer (Models + API)

### 1.1 VideoItem model
- [ ] **TEST**: VideoItem.fromJson парсит JSON корректно (url, name, collection, thumbnailUrl)
- [ ] **CODE**: Создать `VideoItem` data class с полями
- [ ] **TEST**: VideoItem.fromJson обрабатывает snake_case поле `thumbnail_url` -> `thumbnailUrl`
- [ ] **CODE**: Добавить json_serializable или ручной fromJson

### 1.2 ApiResponse model
- [ ] **TEST**: ApiResponse.fromJson парсит `{ "items": [...] }` в список VideoItem
- [ ] **CODE**: Создать `ApiResponse` model

### 1.3 VideoRepository (абстракция)
- [ ] **TEST**: VideoRepository.getVideos() возвращает список VideoItem
- [ ] **CODE**: Создать абстрактный класс `VideoRepository` с методом `getVideos()`

### 1.4 HttpVideoRepository
- [ ] **TEST**: HttpVideoRepository.getVideos() делает GET на `{baseUrl}/api` и парсит ответ (mock http client)
- [ ] **CODE**: Реализовать `HttpVideoRepository`
- [ ] **TEST**: HttpVideoRepository.getVideos() выбрасывает исключение при ошибке сети
- [ ] **CODE**: Обработка ошибок

### 1.5 Вспомогательная логика: сортировка и группировка
- [ ] **TEST**: sortByCollection() сортирует список VideoItem по полю collection
- [ ] **CODE**: Реализовать функцию сортировки
- [ ] **TEST**: groupByCollection() группирует VideoItem по collection, возвращает Map<String, List<VideoItem>>
- [ ] **CODE**: Реализовать функцию группировки
- [ ] **TEST**: getCollectionPreview() возвращает первый VideoItem для каждой коллекции
- [ ] **CODE**: Реализовать функцию

### 1.6 URL resolution
- [ ] **TEST**: resolveUrl(baseUrl, relativePath) корректно склеивает `http://host:8080` + `/media/cats/v.mp4`
- [ ] **CODE**: Реализовать утилиту resolveUrl

---

## Phase 2: Local Persistence (Favorites)

### 2.1 FavoritesRepository (абстракция)
- [ ] **TEST**: FavoritesRepository хранит Set<String> избранных video URL
- [ ] **CODE**: Создать абстрактный класс с методами: `isFavorite(url)`, `toggle(url)`, `getAll()`, `getFavoriteVideos(allVideos)`

### 2.2 SharedPreferencesFavoritesRepository
- [ ] **TEST**: toggle() добавляет URL в избранное, повторный toggle() удаляет
- [ ] **CODE**: Реализовать через SharedPreferences
- [ ] **TEST**: isFavorite() возвращает true для добавленного и false для остальных
- [ ] **CODE**: Реализовать isFavorite
- [ ] **TEST**: getAll() возвращает все сохранённые URL
- [ ] **CODE**: Реализовать getAll
- [ ] **TEST**: getFavoriteVideos() фильтрует список видео по избранным
- [ ] **CODE**: Реализовать getFavoriteVideos

---

## Phase 3: Settings Persistence

### 3.1 SettingsRepository
- [ ] **TEST**: getBaseUrl() возвращает default `http://localhost:8080` если ничего не сохранено
- [ ] **CODE**: Реализовать через SharedPreferences
- [ ] **TEST**: setBaseUrl(url) сохраняет и getBaseUrl() возвращает новое значение
- [ ] **CODE**: Реализовать setBaseUrl

---

## Phase 4: State Management (ViewModels)

### 4.1 VideoListViewModel
- [ ] **TEST**: При load() вызывает repository.getVideos(), состояние переходит loading -> loaded
- [ ] **CODE**: Создать ViewModel с ChangeNotifier, состояния: initial, loading, loaded, error
- [ ] **TEST**: При load() ошибке состояние переходит loading -> error с сообщением
- [ ] **CODE**: Обработка ошибок в ViewModel
- [ ] **TEST**: videos возвращает отсортированный по collection список
- [ ] **CODE**: Применить sortByCollection
- [ ] **TEST**: refresh() перезагружает данные (pull-to-refresh)
- [ ] **CODE**: Реализовать refresh

### 4.2 CollectionsViewModel
- [ ] **TEST**: collections возвращает Map<String, List<VideoItem>> из загруженных видео
- [ ] **CODE**: Реализовать (может делегировать VideoListViewModel или принимать список)
- [ ] **TEST**: collectionPreviews возвращает список (name, thumbnail) для каждой коллекции
- [ ] **CODE**: Реализовать

### 4.3 FavoritesViewModel
- [ ] **TEST**: favoriteVideos возвращает только избранные из общего списка
- [ ] **CODE**: Реализовать через FavoritesRepository + VideoListViewModel
- [ ] **TEST**: toggle(videoUrl) переключает статус и оповещает listeners
- [ ] **CODE**: Реализовать toggle
- [ ] **TEST**: isFavorite(url) корректно возвращает статус
- [ ] **CODE**: Реализовать

### 4.4 PlayerViewModel
- [ ] **TEST**: Инициализация с videoList и startIndex — currentVideo возвращает правильный элемент
- [ ] **CODE**: Создать ViewModel
- [ ] **TEST**: next() переключает на следующее видео, на последнем — остаётся
- [ ] **CODE**: Реализовать next
- [ ] **TEST**: previous() переключает на предыдущее, на первом — остаётся
- [ ] **CODE**: Реализовать previous
- [ ] **TEST**: контекстный список: передали только видео коллекции — свайп в рамках коллекции
- [ ] **CODE**: Убедиться что ViewModel принимает произвольный список

---

## Phase 5: Theme & App Shell

### 5.1 Dark Theme
- [ ] **TEST** (widget): MaterialApp использует dark theme с ColorScheme.fromSeed
- [ ] **CODE**: Создать `app_theme.dart` с тёмной темой
- [ ] **CODE**: Создать `app.dart` с MaterialApp.router, darkTheme

### 5.2 Bottom Navigation Shell
- [ ] **TEST** (widget): Экран содержит BottomNavigationBar с 4 вкладками
- [ ] **CODE**: Создать ShellRoute с NavigationBar (History, Collections, Favorites, Settings)
- [ ] **TEST** (widget): Тап на вкладку переключает отображаемый экран
- [ ] **CODE**: Реализовать переключение через GoRouter StatefulShellRoute

### 5.3 GoRouter configuration
- [ ] **TEST**: Router содержит маршруты: `/`, `/collections`, `/collections/:name`, `/favorites`, `/settings`, `/player`
- [ ] **CODE**: Создать `app_router.dart`

---

## Phase 6: Gallery Grid (Shared Widget)

### 6.1 VideoThumbnail widget
- [ ] **TEST** (widget): Отображает CachedNetworkImage с переданным thumbnail URL
- [ ] **CODE**: Создать VideoThumbnail виджет
- [ ] **TEST** (widget): Показывает placeholder при загрузке и error icon при ошибке
- [ ] **CODE**: Добавить loadingBuilder и errorBuilder

### 6.2 VideoGrid widget (reusable)
- [ ] **TEST** (widget): Отображает GridView с 3 колонками
- [ ] **CODE**: Создать VideoGrid c GridView.builder, crossAxisCount: 3
- [ ] **TEST** (widget): При тапе на ячейку вызывает onVideoTap(index) callback
- [ ] **CODE**: Добавить GestureDetector/InkWell с callback
- [ ] **TEST** (widget): Поддерживает pull-to-refresh (RefreshIndicator)
- [ ] **CODE**: Обернуть в RefreshIndicator

---

## Phase 7: Feature Screens

### 7.1 History Screen
- [ ] **TEST** (widget): Показывает loading indicator при загрузке
- [ ] **CODE**: Создать HistoryScreen, подключить VideoListViewModel
- [ ] **TEST** (widget): Показывает VideoGrid со всеми видео после загрузки
- [ ] **CODE**: Передать videos в VideoGrid
- [ ] **TEST** (widget): Показывает error message при ошибке
- [ ] **CODE**: Обработка состояния error
- [ ] **TEST** (widget): Тап на видео навигирует к плееру с контекстом all videos
- [ ] **CODE**: Реализовать навигацию через GoRouter

### 7.2 Collections Screen
- [ ] **TEST** (widget): Показывает сетку коллекций с названием и превью
- [ ] **CODE**: Создать CollectionsScreen
- [ ] **TEST** (widget): Тап на коллекцию навигирует к CollectionDetailScreen
- [ ] **CODE**: Реализовать навигацию

### 7.3 Collection Detail Screen
- [ ] **TEST** (widget): Показывает название коллекции в AppBar
- [ ] **CODE**: Создать CollectionDetailScreen с параметром collectionName
- [ ] **TEST** (widget): Показывает VideoGrid только с видео выбранной коллекции
- [ ] **CODE**: Фильтрация видео по collection name
- [ ] **TEST** (widget): Тап на видео навигирует к плееру с контекстом коллекции
- [ ] **CODE**: Реализовать навигацию

### 7.4 Favorites Screen
- [ ] **TEST** (widget): Показывает пустое состояние когда нет избранных
- [ ] **CODE**: Создать FavoritesScreen
- [ ] **TEST** (widget): Показывает VideoGrid с избранными видео
- [ ] **CODE**: Подключить FavoritesViewModel
- [ ] **TEST** (widget): Тап на видео навигирует к плееру с контекстом favorites
- [ ] **CODE**: Реализовать навигацию

### 7.5 Settings Screen
- [ ] **TEST** (widget): Показывает текстовое поле с текущим base URL
- [ ] **CODE**: Создать SettingsScreen
- [ ] **TEST** (widget): Кнопка Save сохраняет новый URL через SettingsRepository
- [ ] **CODE**: Реализовать сохранение
- [ ] **TEST** (widget): После сохранения показывает подтверждение (snackbar)
- [ ] **CODE**: Добавить snackbar

---

## Phase 8: Video Player

### 8.1 VideoPlayerScreen (layout)
- [ ] **TEST** (widget): Полноэкранный — скрывает AppBar и BottomNav
- [ ] **CODE**: Создать PlayerScreen как fullscreen route
- [ ] **TEST** (widget): Кнопка back возвращает на предыдущий экран
- [ ] **CODE**: Добавить back button overlay

### 8.2 Like button
- [ ] **TEST** (widget): Показывает иконку heart — filled если избранное, outlined если нет
- [ ] **CODE**: Создать LikeButton виджет
- [ ] **TEST** (widget): Тап переключает статус через FavoritesViewModel
- [ ] **CODE**: Подключить toggle

### 8.3 Progress bar
- [ ] **TEST** (widget): Показывает LinearProgressIndicator внизу экрана
- [ ] **CODE**: Создать VideoProgressBar, привязать к VideoPlayerController.value.position
- [ ] **TEST** (widget): Прогресс обновляется при воспроизведении (mock controller)
- [ ] **CODE**: Слушать controller и обновлять

### 8.4 Video playback
- [ ] **TEST** (unit): PlayerViewModel инициализирует VideoPlayerController с правильным URL
- [ ] **CODE**: Интегрировать video_player package
- [ ] **CODE**: Autoplay при инициализации
- [ ] **CODE**: Loop: controller.setLooping(true)
- [ ] **TEST** (widget): Тап на видео переключает play/pause
- [ ] **CODE**: Реализовать tap to toggle

### 8.5 Swipe navigation
- [ ] **TEST** (widget): Свайп вверх вызывает PlayerViewModel.next()
- [ ] **CODE**: PageView.builder с вертикальным скроллом
- [ ] **TEST** (widget): Свайп вниз вызывает PlayerViewModel.previous()
- [ ] **CODE**: Обработать onPageChanged
- [ ] **TEST** (unit): При переключении видео — dispose старого controller, создать новый
- [ ] **CODE**: Управление lifecycle контроллеров

---

## Phase 9: Integration & Polish

### 9.1 Dependency injection wiring
- [ ] Собрать все repositories и ViewModels в main.dart
- [ ] Прокинуть зависимости через конструкторы и InheritedWidget / ListenableBuilder

### 9.2 Pull-to-refresh integration
- [ ] **TEST** (widget): Pull-to-refresh на History перезагружает данные
- [ ] **TEST** (widget): Pull-to-refresh на Collections перезагружает данные
- [ ] **TEST** (widget): Pull-to-refresh на Favorites перезагружает данные
- [ ] **CODE**: Убедиться что RefreshIndicator вызывает viewModel.refresh()

### 9.3 Error states
- [ ] **TEST** (widget): При ошибке загрузки показывается кнопка Retry
- [ ] **CODE**: Добавить retry на экранах ошибок

### 9.4 Analyze & Format
- [ ] Запустить `dart_format` на всех файлах
- [ ] Запустить `dart_fix` для автоисправлений
- [ ] Запустить `analyze_files` — исправить все warnings

### 9.5 Final smoke test
- [ ] Запустить все unit-тесты
- [ ] Запустить все widget-тесты
- [ ] Ручная проверка на iOS simulator

---

## Порядок зависимостей между фазами

```
Phase 0 (setup)
  |
Phase 1 (models, API) --> Phase 2 (favorites) --> Phase 3 (settings)
  |                           |                       |
  +---------------------------+-----------------------+
  |
Phase 4 (ViewModels)
  |
Phase 5 (theme, nav shell)
  |
Phase 6 (shared grid widget)
  |
Phase 7 (feature screens) --> Phase 8 (player)
  |                               |
  +-------------------------------+
  |
Phase 9 (integration, polish)
```

## Оценка объёма

| Фаза | Кол-во задач | Тестов |
|------|-------------|--------|
| 0. Setup | 5 | 0 |
| 1. Data Layer | 10 | 6 |
| 2. Favorites | 6 | 4 |
| 3. Settings | 3 | 2 |
| 4. ViewModels | 14 | 10 |
| 5. App Shell | 6 | 3 |
| 6. Grid Widget | 6 | 3 |
| 7. Screens | 16 | 10 |
| 8. Player | 12 | 7 |
| 9. Integration | 8 | 3 |
| **Итого** | **~86** | **~48** |
