import { CornerStyle } from '../../model/CornerStyle';
import { CommonCornerRadiusAttribute, CornerRadiusSmallAttributeModifier } from './CornerRadiusAttrbuteModifiers';

/**
 * 头像通用样式。
 */
export class AvatarAttributeModifier extends CornerRadiusSmallAttributeModifier {

  private declare cornerStyle: CornerStyle;
  private declare imageSize: Length;

  constructor(cornerStyle?: CornerStyle, size?: Length) {
    super();
    this.cornerStyle = cornerStyle ?? CornerStyle.ROUND;
    this.imageSize = size ?? $r('app.float.avatar_image_size');
  }

  applyNormalAttribute(instance: CommonCornerRadiusAttribute): void {
    if (this.cornerStyle === CornerStyle.ROUND) {
      instance.borderRadius($r('app.float.corner_radius_small'));
      instance.width(this.imageSize);
      instance.height(this.imageSize);
    } else if (this.cornerStyle === CornerStyle.CIRCLE) {
      instance.width(this.imageSize);
      instance.height(this.imageSize);
      let radius = 0;
      if (typeof this.imageSize === 'number') {
        radius = this.imageSize / 2;
        instance.borderRadius(radius);
      } else if (typeof this.imageSize === 'string'){
        instance.borderRadius(this.imageSize);
      } else {
        radius = getContext().resourceManager.getNumber(this.imageSize) / 2;
        instance.borderRadius(radius);
      }
    }
  }

}