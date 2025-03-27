import { ChatClient, ChatUIKitClient, KitConstants } from "@easemob/chatuikit";
import { LengthMetrics, router } from "@kit.ArkUI";
import { bundleManager, ConfigurationConstant } from "@kit.AbilityKit";

@ComponentV2
export struct MePage {
  @Param pathStack: NavPathStack = new NavPathStack();
  @Local versionName: string = '';

  aboutToAppear(): void {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).then(info => {
      this.versionName = info.versionName;
      let versionNo = info.versionCode;
      console.log('versionName: '+this.versionName + ' versionNo: '+versionNo);
    })
  }

  build() {
    NavDestination() {
      Column() {
        Text('版本：'+this.versionName)
          .margin({
            bottom: LengthMetrics.vp(20)
          })
          .alignSelf(ItemAlign.Start)
        Text('当前用户：'+ChatClient.getInstance().getCurrentUser())
          .margin({
            bottom: LengthMetrics.vp(20)
          })
          .alignSelf(ItemAlign.Start)
        Button('切换暗黑', {type: ButtonType.Capsule})
          .width('40%')
          .margin({
            bottom: LengthMetrics.vp(20)
          })
          .onClick(() => {
            getContext().getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
          })
        Button('退出登录', {type: ButtonType.Capsule})
          .width('40%')
          .margin({
            bottom: LengthMetrics.vp(20)
          })
          .onClick(() => {
            ChatUIKitClient.logout().then(() => {
              this.pathStack.clear();
              router.replaceUrl({url: 'pages/Index'})
            })
          })
      }
      .justifyContent(FlexAlign.Start)
      .width(KitConstants.FULL_WIDTH)
      .padding(40)
    }
    .hideTitleBar(true)
    .width(KitConstants.FULL_WIDTH)
    .height(KitConstants.FULL_HEIGHT)
  }
}