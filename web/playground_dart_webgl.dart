import 'package:playground_dart_webgl/client.dart';

@MirrorsUsed(targets: const [
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('playground_dart_webgl', 'canvas', 800, 600, webgl: true);

  void createEntities() {
    // addEntity([Component1, Component2]);
  }

  List<EntitySystem> getSystems() {
    return [
            new CanvasCleaningSystem3D(canvas),
            new RenderingSystem(canvas)
    ];
  }
}
