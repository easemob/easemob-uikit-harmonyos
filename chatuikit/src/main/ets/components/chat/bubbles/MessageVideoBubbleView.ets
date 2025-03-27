import { ChatError, ChatLog } from '@easemob/chatsdk';
import { MessageItemImageAttributeModifier } from '../../../internal/attributeModifiers/MessageAttributeModifier';
import { kitMedia } from '../../../manager/MediaManager';
import { MessageImageModel } from '../../../model/builder/MessageComponentModel';
import { ChatKitMessage } from '../../../model/ChatKitMessage';
import { imageBuilder } from '../../../shares/builders/CommonBulders';
import { ShowVideoDialog } from '../../../shares/dialogs/ShowVideoDialog';
import { EventBus } from '../../../utils/EventBus';
import {
  getImageShowSize,
  getMsgDownloadThumbnailEvent,
  getVideoThumbnailResource,
  isSender
} from '../../../utils/MessageUtil';
import { MessageItemSentStatusView } from './../MessageComponents';

@ComponentV2
export struct MessageVideoBubbleView {
  @Require @Param message: ChatKitMessage;
  @Param param: MessageImageModel = new MessageImageModel();
  @Local videoThumbnailWidth: Length = $r('app.float.message_item_image_default_size');
  @Local videoThumbnailHeight: Length = $r('app.float.message_item_image_default_size');
  @Local videoThumbnailLocalResource: ResourceStr | undefined = undefined;
  @Param onItemClick: (message: ChatKitMessage) => void = () => {
    kitMedia.openVideoDialog(new CustomDialogController({
      builder: ShowVideoDialog({
        messageId: this.message.messageId
      }),
      cornerRadius: 0,
      alignment: DialogAlignment.Center,
      backgroundColor: Color.Black,
      backgroundBlurStyle: BlurStyle.NONE,
      height: '100%',
      width: '100%',
      customStyle: true
    }));
  }
  @Monitor('message', 'message.attachmentDownloadStatus', 'message.thumbnailDownloadStatus')
  onAttachmentChange(monitor: IMonitor) {
    this.getVideoThumbnailSize();
    this.getVideoThumbnailLocalResource();
  }
  @Consumer('on_error_icon_click') onErrorIconClick: (message: ChatKitMessage) =>void = message => {}
  @Consumer("click_media_message") onMediaClick: (message: ChatKitMessage) => void = message => {};
  @Consumer('on_item_message_click') onItemInnerClick?: (message: ChatKitMessage) => boolean;

  private getVideoThumbnailSize() {
    getImageShowSize(this.message.origin).then((size) => {
      this.videoThumbnailWidth = size.width;
      this.videoThumbnailHeight = size.height;
    }).catch((e: ChatError) => {
      ChatLog.e('getImageSize: '+e.description);
      this.videoThumbnailWidth = $r('app.float.message_item_image_default_size');
      this.videoThumbnailHeight = $r('app.float.message_item_image_default_size');
    })
  }

  private getVideoThumbnailLocalResource() {
    this.videoThumbnailLocalResource = getVideoThumbnailResource(this.message, (messageId: string) => {
      new EventBus().emit(getMsgDownloadThumbnailEvent(), messageId);
    });
  }

  private getVideoFlagSize() {
    let flagSize = px2vp(getContext().resourceManager.getNumber($r('app.float.message_item_video_flag_size').id));
    if (typeof this.videoThumbnailWidth === 'number' && typeof this.videoThumbnailHeight === 'number') {
      const thumbnailSize = Math.min(this.videoThumbnailWidth, this.videoThumbnailHeight);
      if (thumbnailSize <= flagSize) {
        return thumbnailSize * 0.5;
      }
    }
    return flagSize;
  }

  aboutToAppear(): void {
    this.getVideoThumbnailSize();
    this.getVideoThumbnailLocalResource();
  }

  build() {
    Row() {
      if (isSender(this.message.origin)) {
        MessageItemSentStatusView({
          message: this.message,
          onErrorClick: this.onErrorIconClick
        })
        Blank(4)
      }
      if (this.videoThumbnailLocalResource) {
        Stack({alignContent: Alignment.Center}) {
          imageBuilder({
            src: this.videoThumbnailLocalResource,
            width: this.videoThumbnailWidth,
            height: this.videoThumbnailHeight,
            attributeModifier: this.param.attributeModifier ?? new MessageItemImageAttributeModifier()
          })

          imageBuilder({
            src: $r('app.media.message_video_flag'),
            width: this.getVideoFlagSize(),
            height: this.getVideoFlagSize(),
          })
        }
      } else {
        imageBuilder({
          src: $r("app.media.quote_default_video_icon"),
          width: this.videoThumbnailWidth,
          height: this.videoThumbnailHeight,
        })
      }
    }
    .alignItems(VerticalAlign.Bottom)
    .onClick(() => {
      this.onMediaClick(this.message);
      if (this.onItemInnerClick && this.onItemInnerClick(this.message)) {
        return;
      }
      this.onItemClick(this.message);
    })
  }
}
