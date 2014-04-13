part of client;


class InputHandlingSystem extends EntityProcessingSystem {
  ComponentMapper<Acceleration> am;
  CanvasElement canvas;
  Map<int, bool> keyState = {};
  InputHandlingSystem(this.canvas) : super(Aspect.getAspectForAllOf([Player, Acceleration]));


  @override
  void initialize() {
    window.onKeyDown.listen((event) => handle(event, true));
    window.onKeyUp.listen((event) => handle(event, false));
  }

  void handle(KeyboardEvent event, bool state) {
    keyState[event.keyCode] = state;
  }


  @override
  void processEntity(Entity entity) {
    if (keyState[KeyCode.D] == true) {
      am.get(entity).value.x = 10.0;
    } else if (keyState[KeyCode.A] == true) {
      am.get(entity).value.x = -10.0;
    } else {
      am.get(entity).value.x = 0.0;
    }
  }
}