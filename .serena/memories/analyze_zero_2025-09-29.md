2025-09-29: Fixed all flutter analyze issues to zero.
- Removed unused import in lib/presentation/pages/diary_edit_page.dart (markdown_widget).
- Replaced print with debugPrint within assert in lib/presentation/pages/search_page.dart; removed unnecessary foundation import per analyzer.
- Removed unused local function pumpUntilGone in test/diary_edit_save_flows_test.dart.
- Verified: flutter analyze -> No issues found.