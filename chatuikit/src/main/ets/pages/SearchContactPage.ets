import { ConversationType } from '@easemob/chatsdk';
import { SearchContactView } from '../components/search/SearchView';
import { ChatKitContact } from '../model/ChatKitContact';
import { ChatPageParams, SearchContactPageParams, SearchContactResponseType } from '../model/PageParams';
import { BaseContactListViewModel, ContactListViewModel } from '../viewmodels/ContactViewModel';
import { ArrayList } from '@kit.ArkTS';

@ComponentV2
export struct SearchContactPage {
  @Event onItemClick: Callback<ChatKitContact> = (item) => {
    if (this.responseType === SearchContactResponseType.chat) {
      this.pathStack.pushPath({name: "ChatPage", param: {
        conversationId: item.id,
        conversationType: ConversationType.Chat
      } as ChatPageParams
      })
    } else if (this.responseType === SearchContactResponseType.onPop) {
      this.pathStack.pop(item);
    }
  }
  pathStack: NavPathStack = new NavPathStack();
  responseType: SearchContactResponseType = SearchContactResponseType.chat;

  build() {
    NavDestination() {
      SearchContactView({
        onBackPress: () => {
          this.pathStack.pop();
        },
        onItemClick: this.onItemClick
      })
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
      if (this.pathStack) {
        let params = this.pathStack.getParamByName('SearchContactPage') as SearchContactPageParams[];
        if (params) {
          let param = params[0];
          if (param) {
            this.responseType = param.responseType
          }
        }
      }
    })
  }
}

@Builder
export function SearchContactPageBuilder() {
  SearchContactPage()
}

@ComponentV2
export struct ContactSearchSelectorPage {
  @Local viewModel: BaseContactListViewModel = new ContactListViewModel();
  @Monitor('viewModel.searchResult')
  onSearchResult(monitor: IMonitor) {
    this.viewModel.searchResult.forEach(item => {
      if (this.selectedContact.length > 0 && this.selectedContact.has(item.id)) {
        if (!item.isChecked) {
          item.isChecked = true;
        }
      }
    })
  }
  @Event onItemClick: Callback<ChatKitContact> = (contact) => {
    contact.isChecked = !contact.isChecked;
    if (contact.isChecked && !this.selectedContact.has(contact.id)) {
      this.selectedContact.add(contact.id);
    } else if (!contact.isChecked && this.selectedContact.has(contact.id)) {
      this.selectedContact.remove(contact.id);
    }
    this.updateCancelText();
  }
  pathStack: NavPathStack = new NavPathStack();
  @Local cancelText: ResourceStr = $r('app.string.cancel');
  @Local selectedContact: ArrayList<string> = new ArrayList();

  private updateCancelText() {
    if (this.selectedContact?.length > 0) {
      this.cancelText = $r('app.string.confirm');
    } else {
      this.cancelText = $r('app.string.cancel');
    }
  }

  build() {
    NavDestination() {
      SearchContactView({
        viewModel: this.viewModel,
        onSubmit: (value) => {
          this.viewModel.searchContacts(value);
        },
        onBackPress: () => {
          this.pathStack.pop(this.selectedContact);
        },
        onItemClick: this.onItemClick,
        isCheckModel: true,
        cancelText: this.cancelText
      })
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.pathStack = context.pathStack
      if (this.pathStack && this.pathStack.getParamByName('ContactSearchSelectorPage')) {
        let params = this.pathStack.getParamByName('ContactSearchSelectorPage') as ArrayList<string>[];
        if (params) {
          let param = params[0];
          this.selectedContact = param;
          this.updateCancelText();
        }
      }
    })
  }
}

@Builder
export function ContactSearchSelectorPageBuilder() {
  ContactSearchSelectorPage()
}