import 'dart:html';
import 'dart:web_gl';
import 'dart:typed_data';

/**
 * Links:
 * * [http://learningwebgl.com/blog/?page_id=1217]
 * * [http://martinsikora.com/dart-webgl-simple-demo]
 * * [http://www.netmagazine.com/tutorials/get-started-webgl-draw-square]
 * * [https://www.khronos.org/registry/webgl/specs/latest/]
 * * [http://nehe.gamedev.net/]
 * * [https://www.youtube.com/watch?v=rfQ8rKGTVlg]
 */

void main() {

  CanvasElement canvas = querySelector('canvas');

  AnchorElement link = querySelector('a#lesson001');
  link.onClick.listen((e) {
    Lesson lesson = new Lesson001(canvas);
    lesson.start();
  });
  link = querySelector('a#lesson002');
  link.onClick.listen((e) {
    Lesson lesson = new Lesson002(canvas);
    lesson.start();
  });
  link = querySelector('a#lesson003');
  link.onClick.listen((e) {
    Lesson lesson = new Lesson003(canvas);
    lesson.start();
  });

  Lesson lesson = new Lesson004(canvas);
  lesson.start();
}

abstract class Lesson {
  void start();
}

class Lesson001 implements Lesson {

  CanvasElement canvas;
  Lesson001(this.canvas);

  void start() {
    canvas.width = 800;
    canvas.height = 800;

    RenderingContext gl = canvas.getContext3d();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0, 0, 0, 1);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT);
  }
}

class Lesson002 implements Lesson  {

  CanvasElement canvas;
  Lesson002(this.canvas);

  final String attrVertexPosition = "aVertexPosition";
  final String uWorldViewProjection = "worldViewProjection";
  final String colorVariable = "uColor";

  void start() {
    canvas.width = 800;
    canvas.height = 800;

    RenderingContext gl = canvas.getContext3d();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0, 0, 0, 1);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT);

    String vertex = """
      attribute vec2 $attrVertexPosition;
        
      void main() {
        mat4 view = mat4( vec4(1, 0, 0, 0),
                          vec4(0, 1, 0, 0),
                          vec4(0, 0, 1, 0),
                          vec4(0, 0, 0, 1));
        mat4 world = mat4(vec4(1, 0, 0, 0),
                          vec4(0, 1, 0, 0),
                          vec4(0, 0, 1, 0),
                          vec4(0, 0, 0, 1));
        mat4 worldViewProjection = view * world;
        gl_Position = (worldViewProjection * vec4($attrVertexPosition, 0.0, 1.0));
      }
    """;

    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vertex);
    gl.compileShader(vs);

    String fragment = """
      #ifdef GL_ES
      precision highp float;
      #endif
        
      uniform vec4 $colorVariable;
        
      void main() {
        gl_FragColor = $colorVariable;
      }
    """;

    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fragment);
    gl.compileShader(fs);

    Program program = gl.createProgram();
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


    Float32List vertices = new Float32List.fromList(
        [
         0.5, 0.5, -0.5, 0.5, 0.5, -0.5, // Triangle 1
         -0.5, 0.5, 0.5, -0.5, -0.5, -0.5 // Triangle 2
        ]);

    Buffer squareBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, squareBuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, vertices, RenderingContext.STATIC_DRAW);

    int itemSize = 2;
    int numItems = vertices.length ~/ itemSize;

    gl.useProgram(program);

    UniformLocation uColor = gl.getUniformLocation(program, colorVariable);
    gl.uniform4fv(uColor, new Float32List.fromList([0.9, 0.3, 0.0, 0.5]));

    int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, itemSize, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, numItems);
  }

}


class Lesson003 implements Lesson  {

  CanvasElement canvas;
  Lesson003(this.canvas);

  final String vertexPositionAttribute = "aVertexPosition";
  final String colorVariable = "uColor";

  void start() {
    canvas.width = 800;
    canvas.height = 800;

    RenderingContext gl = canvas.getContext3d();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0, 0.5, 0, 1);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT);

    String vertex = """
      attribute vec2 $vertexPositionAttribute;
        
      void main() {
        gl_Position = vec4($vertexPositionAttribute, 0.0, 1.0);
      }
    """;

    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vertex);
    gl.compileShader(vs);

    String fragment = """
      #ifdef GL_ES
      precision highp float;
      #endif
        
      uniform vec4 $colorVariable;
        
      void main() {
        gl_FragColor = $colorVariable;
      }
    """;

    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fragment);
    gl.compileShader(fs);

    Program program = gl.createProgram();
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

    Float32List vertices = new Float32List.fromList(
        [
         -0.4, 0.6, 0.6, 0.6, 0.6, -0.4, // Triangle 1
         -0.6, 0.4, 0.4, -0.6, -0.6, -0.6 // Triangle 2
        ]);

    Buffer vbuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, vbuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, vertices, RenderingContext.STATIC_DRAW);

    int itemSize = 2;
    int numItems = vertices.length ~/ itemSize;

    gl.useProgram(program);

    UniformLocation uColor = gl.getUniformLocation(program, colorVariable);
    gl.uniform4fv(uColor, new Float32List.fromList([0.9, 0.3, 0.0, 0.5]));

    int aVertextPosition = gl.getAttribLocation(program, vertexPositionAttribute);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, itemSize, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, numItems);
  }
}


class Lesson004 implements Lesson  {

  CanvasElement canvas;
  Lesson004(this.canvas);

  final String attrVertex = "attrVertex";
  final String uPosition = "attrPosition";
  final String uColor = "uColor";

  void start() {
    canvas.width = 800;
    canvas.height = 800;

    RenderingContext gl = canvas.getContext3d();

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0, 0, 0, 1);
    gl.clear(RenderingContext.COLOR_BUFFER_BIT);

    String vertex = """
      attribute vec2 $attrVertex;
      uniform vec3 $uPosition;
        
      void main() {
        mat4 pMatrix = mat4(vec4(1, 0, 0, 0),
                            vec4(0, 1, 0, 0),
                            vec4(0, 0, -1, -1),
                            vec4(0, 0, -0.2, 0));
        mat4 mvMatrix = mat4(vec4(1, 0, 0, 0),
                             vec4(0, 1, 0, 0),
                             vec4(0, 0, 1, 0),
                             vec4(vec3($uPosition), 1));
        gl_Position = pMatrix * mvMatrix * vec4($attrVertex, 0, 1.0);
      }
    """;

    Shader vs = gl.createShader(RenderingContext.VERTEX_SHADER);
    gl.shaderSource(vs, vertex);
    gl.compileShader(vs);

    String fragment = """
      #ifdef GL_ES
      precision highp float;
      #endif
        
      uniform vec4 $uColor;
        
      void main() {
        gl_FragColor = $uColor;
      }
    """;

    Shader fs = gl.createShader(RenderingContext.FRAGMENT_SHADER);
    gl.shaderSource(fs, fragment);
    gl.compileShader(fs);

    Program program = gl.createProgram();
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


    Float32List vertices = new Float32List.fromList(
        [
         0.5, 0.5, -0.5, 0.5, 0.5, -0.5, // Triangle 1
         -0.5, -0.5, -0.5, 0.5, 0.5, -0.5 // Triangle 2
        ]);

    Buffer squareBuffer = gl.createBuffer();
    gl.bindBuffer(RenderingContext.ARRAY_BUFFER, squareBuffer);
    gl.bufferData(RenderingContext.ARRAY_BUFFER, vertices, RenderingContext.STATIC_DRAW);

    int itemSize = 2;
    int numItems = vertices.length ~/ itemSize;

    gl.useProgram(program);

    UniformLocation varColor = gl.getUniformLocation(program, uColor);
    gl.uniform4fv(varColor, new Float32List.fromList([0.9, 0.3, 0.0, 0.5]));

    UniformLocation varPosition = gl.getUniformLocation(program, uPosition);
    gl.uniform3fv(varPosition, new Float32List.fromList([-1.5, 0.0, -7.0]));

    int aVertextPosition = gl.getAttribLocation(program, attrVertex);
    gl.enableVertexAttribArray(aVertextPosition);
    gl.vertexAttribPointer(aVertextPosition, itemSize, RenderingContext.FLOAT, false, 0, 0);

    gl.drawArrays(RenderingContext.TRIANGLES, 0, numItems);
  }

}

