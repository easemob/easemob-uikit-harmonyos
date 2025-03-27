import uikit from '../internal/ChatUIKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ChatLog } from '../../../../Index';

export function getString(resource: Resource, arg?: string | number): string {
  try {
    if (arg != undefined) {
      return getContext().resourceManager.getStringSync(resource, arg);
    }
    return getContext().resourceManager.getStringSync(resource);
  } catch (e) {
    let code = (e as BusinessError).code;
    let message = (e as BusinessError).message;
    ChatLog.d('getString failed: error code: '+code+', message: '+message);
  }
  return '';
}

export function getNumber(resource: Resource): number {
  try {
    return getContext().resourceManager.getNumber(resource);
  } catch (error) {
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    ChatLog.d(`getNumber failed, error code: ${code}, message: ${message}.`);
  }
  return 0;
}

/**
 * 对key拼接前缀。
 * @param key
 * @param userId
 * @returns
 */
export function appendFlag(key: string, userId?: string): string {
  let prefix: string = '';
  if (!userId) {
    prefix = uikit.sdk.getCurrentUser();
  } else {
    prefix = userId;
  }
  return prefix + '_' + key;
}