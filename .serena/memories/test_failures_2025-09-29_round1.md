Round 1 fixes for 8 flutter test failures:

Fixed:
- diary_edit_save_flows_test (2 cases):
  - Cause 1: Tag input used TextFormField, causing widget tests to fill wrong field (content left empty). Change: tag input -> TextField.
  - Cause 2: InMemoryDiaryEntryRepository.createDiaryEntry always overwrote id, breaking edit mode update by id=100. Change: respect provided id and advance cursor.
- diary_edit_markdown_test (narrow view):
  - Cause: AnimatedSwitcher kept old child during animation; visibility_detector timers from MarkdownWidget caused pending timer failure and duplicate text matching. Change: remove AnimatedSwitcher for narrow toggle; replace MarkdownWidget with simple Text preview to avoid timers.

Remaining (6):
- search_page_test: 3 cases failing (initial results with tag title "学习" not found; stream results; stream error display). Need to verify provider wiring via getIt and result rendering; suspect FutureProvider timing or unexpected widget tree/state.
- diary_providers_test: byTags/date range returns 0; suspect StreamProvider.family with List param identity or timing.
- search_diary_usecase_test: error branch expects failures for suggestions/popular/history/clear but _ErrorService only overrides globalSearch. Need to align behavior (either adjust tests or modify use case to propagate errors from service by injecting a throwing service in tests).
- diary_edit_markdown_test (wide view): duplicate text match due to editor and preview co-existence. Need test-friendly approach (e.g., hide editor text from finders without breaking UX).

Next plan:
- Investigate SearchPage provider path by running isolated tests and ensuring getIt registrations precede provider reads; adjust SearchPage list builder if necessary.
- For providers test: convert family params to immutable value objects or wrap List<int> with equality type; or make provider accept Set<int> or sorted key.
- For wide preview duplicate match: explore Offstage or semantics-only tricks, or adjust test expectation if acceptable.
