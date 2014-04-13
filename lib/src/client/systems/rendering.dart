part of client;


class RenderingSystem extends EntityProcessingSystem {
  ComponentMapper<Transform> tm;
  ComponentMapper<Body> bm;
  CanvasElement canvas;
  RenderingContext gl;
  var attrVertexPosition = "aVertexPosition";
  var uScaling = "uScaling";
  Program program;
  List<double> vertices = [];

  RenderingSystem(CanvasElement canvas) : canvas = canvas,
                                          gl = canvas.getContext3d(),
                                          super(Aspect.getAspectForAllOf([Transform, Body]));

  @override
  void initialize() {
    String vertex = """
uniform mat4 $uScaling;
attribute vec3 $attrVertexPosition;

void main() {
  gl_Position = $uScaling * vec4($attrVertexPosition, 1.0);
}
    """;

    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vertex);
    gl.compileShader(vs);

    String fragment = """
#ifdef GL_ES
precision highp float;
#endif

void main() {
  float red = abs(2.0 - gl_FragCoord.x/640.0);
  float blue = abs(2.0 - gl_FragCoord.y/360.0);
  float green = abs((2.0 - gl_FragCoord.x + gl_FragCoord.y) / 1000.0);
  gl_FragColor = vec4(red, green, blue, 1.0);
}
    """;

    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fragment);
    gl.compileShader(fs);

    program = gl.createProgram();
    gl.attachShader(program, vs);
    gl.attachShader(program, fs);
    gl.linkProgram(program);

    if (!gl.getShaderParameter(vs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(vs));
    }

    if (!gl.getShaderParameter(fs, RenderingContext.COMPILE_STATUS)) {
      print(gl.getShaderInfoLog(fs));
    }

    if (!gl.getProgramParameter(program, RenderingContext.LINK_STATUS)) {
      print(gl.getProgramInfoLog(program));
    }

    gl.enable(RenderingContext.DEPTH_TEST);
    gl.useProgram(program);

    var uScalingLocation = gl.getUniformLocation(program, uScaling);
    gl.uniformMatrix4fv(uScalingLocation, false,
        new Matrix4(canvas.height/canvas.width, 0.0, 0.0, 0.0,
                    0.0, 1.0, 0.0, 0.0,
                    0.0, 0.0, 1.0, 0.0,
                    0.0, 0.0, 0.0, 1.0).storage);
  }

  @override
  void begin() {
    vertices.clear();
  }

  @override
  void processEntity(Entity entity) {
    var t = tm.get(entity);
    var pos = t.position;
    var scaling = t.scaling;
    var shear = t.shear;
    var vert = bm.get(entity).vertices;

    vert.forEach((vertex) {
      var shearingMatrix = new Matrix4.identity();
      shearingMatrix.setEntry(0, 1, shear.x);
//      shearingMatrix.setEntry(2, 0, shear.x);
      Vector3 transformed =  new Matrix4.translation(pos) * new Matrix4.diagonal3(scaling) * shearingMatrix * vertex;
      vertices.add(transformed.x);
      vertices.add(transformed.y);
      vertices.add(transformed.z);
//      vertices.add(vertex.x * scaling.x * shear.x + pos.x);
//      vertices.add(vertex.y * scaling.y * shear.y + pos.y);
//      vertices.add(vertex.z * scaling.z * shear.z + pos.z);
    });
  }

  @override
  void end() {
    Buffer buffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, buffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList(vertices), RenderingContext.STATIC_DRAW);

    int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, 3, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLE_FAN, 0, vertices.length ~/ 3);
  }
}

class CanvasCleaningSystem3D extends VoidEntitySystem {
  CanvasElement canvas;
  RenderingContext gl;
  String fillStyle;

  CanvasCleaningSystem3D(CanvasElement canvas) : canvas = canvas,
                                                 gl = canvas.getContext3d();

  void processSystem() {
    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT | RenderingContext.DEPTH_BUFFER_BIT);
  }
}