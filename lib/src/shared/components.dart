part of shared;


class Transform extends Component {
  Vector3 position;
  Vector3 scaling = new Vector3(1.0, 1.0, 1.0);
  Vector3 shear = new Vector3.zero();
  Transform(this.position);
}

class Body extends Component {
  List<Vector3> vertices;
  Body(this.vertices);
}

class Player extends Component {}
class Acceleration extends Component {
  Vector3 value;
  Acceleration(this.value);
}
class Velocity extends Component {
  Vector3 value;
  Velocity(this.value);
}