/**
 * 给函数的执行加上动画
 * @param func：要在动画内执行的回调函数，通常func里面会改变状态变量
 * @param duration：动画持续时长
 * @param curve：动画区线
 */
export function runWithAnimation(
  func: Function,
  duration: number = 300,
  curve: Curve = Curve.Smooth): void {
  animateTo({ duration: duration, curve: curve }, () => {
    func();
  })
}