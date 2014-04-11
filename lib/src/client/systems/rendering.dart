part of client;


class RenderingSystem extends VoidEntitySystem {
  RenderingContext gl;
  var attrVertexPosition = "aVertexPosition";
  Program program;

  RenderingSystem(CanvasElement canvas) : gl = canvas.getContext3d();

  @override
  void initialize() {
    String vertex = """
attribute vec3 $attrVertexPosition;

void main() {
  gl_Position = vec4($attrVertexPosition, 1.0);
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
  float red = abs(2.0 - gl_FragCoord.x/400.0);
  float blue = abs(2.0 - gl_FragCoord.y/300.0);
  float green = abs((2.0 - gl_FragCoord.x + gl_FragCoord.y) / 700.0);
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
  }

  void processSystem() {
    Buffer squareBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, squareBuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, new Float32List.fromList([-1.0, 1.0, 0.0, -1.0, -1.0, 0.0, 1.0, -1.0, 0.0]), RenderingContext.STATIC_DRAW);

    int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, 3, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, 3);
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