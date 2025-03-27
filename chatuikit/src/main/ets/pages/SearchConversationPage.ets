import { SearchConversationView } from '../components/search/SearchView';
import { ChatKitConversation } from '../model/ChatKitConversation';
import { ChatPageParams } from '../model/PageParams';

@ComponentV2
export struct SearchConversationPage {
  @Event onItemClick: Callback<ChatKitConversation> = (item) => {
    this.pathStack.pushPath({name: "ChatPage", param: {
        conversationId: item.conversationId,
        conversationType: item.type
      } as ChatPageParams
    })
  }
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      SearchConversationView({
        onBackPress: () => {
          this.pathStack.pop();
        },
        onItemClick: this.onItemClick
      })
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
    })
  }
}

@Builder
export function SearchConversationPageBuilder() {
  SearchConversationPage()
}