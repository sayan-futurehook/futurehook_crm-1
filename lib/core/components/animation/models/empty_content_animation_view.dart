import 'package:futurehook_crm/core/components/animation/lottie_animation_view.dart';
import 'package:futurehook_crm/core/components/animation/models/lottie_animation.dart';

class EmptyContentAnimationView extends LottieAnimationView {
  const EmptyContentAnimationView({super.key})
      : super(
          animation: LottieAnimation.empty,
        );
}
