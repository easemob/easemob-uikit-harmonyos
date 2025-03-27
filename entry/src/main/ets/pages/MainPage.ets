import { ContactListPage, ConversationListPage } from '@easemob/chatuikit';
import { MePage } from './MePage';

@Entry
@ComponentV2
struct MainPage {
  pathStack: NavPathStack = new NavPathStack();
  @Local pageIndex: number = 0;

  build() {
    Navigation(this.pathStack) {
      if (this.pageIndex === 0) {
        ConversationListPage({
          pathStack: this.pathStack
        });
      } else if (this.pageIndex === 1) {
        ContactListPage({
          pathStack: this.pathStack
        })
      } else if (this.pageIndex === 2) {
        MePage({
          pathStack: this.pathStack
        })
      }
    }
    .height('100%')
    .hideTitleBar(true)
    .toolbarConfiguration([
      {
        value: $r("app.string.main_tab_message"),
        status: this.pageIndex == 0 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.main_tab_icon_message"),
        activeIcon: $r('app.media.main_tab_icon_message_select'),
        action: () => {
          this.pageIndex = 0;
        }
      },
      {
        value: $r("app.string.main_tab_contact"),
        status: this.pageIndex == 1 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.main_tab_icon_contact"),
        activeIcon: $r('app.media.main_tab_icon_contact_select'),
        action: () => {
          this.pageIndex = 1;
        }
      },
      {
        value: $r("app.string.main_tab_me"),
        status: this.pageIndex == 2 ? ToolbarItemStatus.ACTIVE : ToolbarItemStatus.NORMAL,
        icon: $r("app.media.main_tab_icon_me"),
        activeIcon: $r('app.media.main_tab_icon_me_select'),
        action: () => {
          this.pageIndex = 2;
        }
      }
    ])
  }
}

