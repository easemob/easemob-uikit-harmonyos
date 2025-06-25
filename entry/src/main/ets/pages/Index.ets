import { ChatError, ChatUIKitClient } from '@easemob/chatuikit';

@Entry
@ComponentV2
struct Index {
  pathStack: NavPathStack = new NavPathStack();
  private userId: string = '';
  private token: string = '';

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
      TextInput({placeholder: "Token", text: this.token})
        .margin({
          top: 20
        })
        .width('80%')
        .onChange((value) => {
          this.token = value;
        })
      Button("登录")
        .margin({
          top: 20
        })
        .width('80%')
        .onClick(() => {
          if (!this.userId || !this.token) {
            this.getUIContext().getPromptAction().showToast({message: "用户名或者Token不能为空！"})
            return;
          }
          ChatUIKitClient.login(this.userId, this.token).then(() => {
            this.getUIContext().getRouter().replaceUrl({url: 'pages/MainPage'});
          }).catch((e: ChatError) => {
            this.getUIContext().getPromptAction().showToast({message: "Login failed: "+e.description});
          })
        })
    }
    .width('100%')
    .height('100%')
  }
}