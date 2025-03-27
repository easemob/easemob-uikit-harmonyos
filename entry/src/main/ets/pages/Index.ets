import { ChatError, ChatUIKitClient } from '@easemob/chatuikit';
import { promptAction, router } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = new NavPathStack();
  private userId: string = '';
  private password: string = '';

  build() {
    Column() {
      TextInput({placeholder: "UserId"})
        .margin({
          top: 40
        })
        .width('80%')
        .onChange((value) => {
          this.userId = value;
        })
      TextInput({placeholder: "password"})
        .margin({
          top: 20
        })
        .width('80%')
        .type(InputType.Password)
        .onChange((value) => {
          this.password = value;
        })
      Button("登录")
        .margin({
          top: 20
        })
        .width('80%')
        .onClick(() => {
          if (!this.userId || !this.password) {
            promptAction.showToast({message: "用户名或者密码不能为空！"})
            return;
          }
          ChatUIKitClient.login(this.userId, this.password).then(() => {
            router.pushUrl({url: 'pages/MainPage'});
          }).catch((e: ChatError) => {
            promptAction.showToast({message: "Login failed: "+e.description});
          })
        })
    }
    .width('100%')
    .height('100%')
  }
}