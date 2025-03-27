import { ConversationType } from '@easemob/chatsdk';

/**
 * 跳转到ChatPage页面需要携带的参数
 */
export class ChatPageParams {
  conversationId: string = '';
  conversationType: ConversationType = ConversationType.Chat;
}

/**
 * 搜索页面参数
 * 主要是点击后的响应。
 */
export class SearchContactPageParams {
  responseType: SearchContactResponseType = SearchContactResponseType.chat
}

export enum SearchContactResponseType {
  /**
   * 带参数返回
   */
  onPop,
  /**
   * 跳转到聊天页面
   */
  chat
}