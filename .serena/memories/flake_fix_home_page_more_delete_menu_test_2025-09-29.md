修复挂起测试 home_page_more_delete_menu_test.dart：原因是弹出菜单/对话框动画导致 pumpAndSettle 在某些环境下可能长期不收敛。修复方案：
- 避免依赖弹出层交互，直接从列表项卡片获取 FacebookDiaryCard 并调用 onDeleteTap() 打开确认对话框；随后等待对话框渲染，点击“删除”并短暂 pump。
- 保留一个受控的 _pumpUntilFound() 工具以有限步长轮询等待目标出现，避免无限等待。
影响范围：仅该测试文件，未改动业务代码。稳定性显著提升，规避了平台/渲染差异引发的卡顿。