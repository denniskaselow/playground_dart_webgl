part of shared;


class DefaultAnimationSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;

  DefaultAnimationSystem() : super(Aspect.getAspectForAllOf([Transform]));

  @override
  void processEntity(Entity entity) {
    var scaling = tm.get(entity).scaling;

    scaling.x = 1.00 + sin(world.frame / 20) / 30;
    scaling.y = 1.00 - sin(world.frame / 20) / 50;
  }
}

class AccelerationSystem extends EntityProcessingSystem {
  ComponentMapper<Acceleration> am;
  ComponentMapper<Velocity> vm;
  AccelerationSystem() : super(Aspect.getAspectForAllOf([Acceleration, Velocity]));


  @override
  void processEntity(Entity entity) {
    var v = vm.get(entity);
    var a = am.get(entity);

    v.value = v.value + a.value * world.delta / 1000.0;
  }
}

class MovementSystem extends EntityProcessingSystem {
  ComponentMapper<Velocity> vm;
  ComponentMapper<Transform> tm;
  MovementSystem() : super(Aspect.getAspectForAllOf([Velocity, Transform]));


  @override
  void processEntity(Entity entity) {
    var v = vm.get(entity);
    var t = tm.get(entity);

    t.position = t.position + v.value * world.delta / 1000.0;
  }
}

class ShearingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Acceleration> am;
  ShearingSystem() : super(Aspect.getAspectForAllOf([Transform, Acceleration]));

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var a = am.get(entity);

    t.shear += new Vector3.copy(a.value / 1000.0);
  }
}