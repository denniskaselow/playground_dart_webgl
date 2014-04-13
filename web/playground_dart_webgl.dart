import 'package:playground_dart_webgl/client.dart';

@MirrorsUsed(targets: const [RenderingSystem, DefaultAnimationSystem,
                             InputHandlingSystem, AccelerationSystem,
                             MovementSystem, ShearingSystem
                            ])
import 'dart:mirrors';

void main() {
  new Game().start();
}

class Game extends GameBase {

  Game() : super.noAssets('playground_dart_webgl', 'canvas', 1280, 720, webgl: true);

  void createEntities() {
     addEntity([new Transform(new Vector3(0.0, -0.4, 0.0)),
                new Acceleration(new Vector3(0.0, 0.0, 0.0)),
                new Velocity(new Vector3(0.0, 0.0, 0.0)),
                new Player(),
                new Body([new Vector3(0.2, 0.0, 0.0),
                          new Vector3(0.2, 0.8, 0.0),
                          new Vector3(-0.2, 0.8, 0.0),
                          new Vector3(-0.2, 0.0, 0.0),
                          ])]);
  }

  List<EntitySystem> getSystems() {
    return [
            new InputHandlingSystem(canvas),
            new ShearingSystem(),
            new AccelerationSystem(),
            new MovementSystem(),
            new DefaultAnimationSystem(),
            new CanvasCleaningSystem3D(canvas),
            new RenderingSystem(canvas)
    ];
  }
}
