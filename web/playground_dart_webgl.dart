#import("dart:html");

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

  CanvasElement canvas = query('canvas');

  AnchorElement link = query('a#lesson001');
  link.on.click.add((e) {
    Lesson lesson = new Lesson001(canvas);
    lesson.start();
  });
  link = query('a#lesson002');
  link.on.click.add((e) {
    Lesson lesson = new Lesson002(canvas);
    lesson.start();
  });
  link = query('a#lesson003');
  link.on.click.add((e) {
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
    canvas.parent.rect.then((ElementRect rect) {
      canvas.width = 800;
      canvas.height = 800;

      WebGLRenderingContext gl = canvas.getContext('experimental-webgl');

      gl.viewport(0, 0, canvas.width, canvas.height);
      gl.clearColor(0, 0, 0, 1);
      gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT);


    });
  }
}

class Lesson002 implements Lesson  {

  CanvasElement canvas;
  Lesson002(this.canvas);

  final String attrVertexPosition = "aVertexPosition";
  final String uWorldViewProjection = "worldViewProjection";
  final String colorVariable = "uColor";

  void start() {
    canvas.parent.rect.then((ElementRect rect) {
      canvas.width = 800;
      canvas.height = 800;

      WebGLRenderingContext gl = canvas.getContext('experimental-webgl');

      gl.viewport(0, 0, canvas.width, canvas.height);
      gl.clearColor(0, 0, 0, 1);
      gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT);

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

      WebGLShader vs = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
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

      WebGLShader fs = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
      gl.shaderSource(fs, fragment);
      gl.compileShader(fs);

      WebGLProgram program = gl.createProgram();
      gl.attachShader(program, vs);
      gl.attachShader(program, fs);
      gl.linkProgram(program);

      if (!gl.getShaderParameter(vs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(vs));
      }

      if (!gl.getShaderParameter(fs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(fs));
      }

      if (!gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS)) {
        print(gl.getProgramInfoLog(program));
      }


      Float32Array vertices = new Float32Array.fromList(
          [
           0.5, 0.5, -0.5, 0.5, 0.5, -0.5, // Triangle 1
           -0.5, 0.5, 0.5, -0.5, -0.5, -0.5 // Triangle 2
          ]);

      WebGLBuffer squareBuffer = gl.createBuffer();
      gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, squareBuffer);
      gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, vertices, WebGLRenderingContext.STATIC_DRAW);

      int itemSize = 2;
      int numItems = vertices.length ~/ itemSize;

      gl.useProgram(program);

      WebGLUniformLocation uColor = gl.getUniformLocation(program, colorVariable);
      gl.uniform4fv(uColor, new Float32Array.fromList([0.9, 0.3, 0.0, 0.5]));

      int aVertextPosition = gl.getAttribLocation(program, attrVertexPosition);
      gl.enableVertexAttribArray(aVertextPosition);
      gl.vertexAttribPointer(aVertextPosition, itemSize, WebGLRenderingContext.FLOAT, false, 0, 0);

      gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, numItems);
    });
  }

}


class Lesson003 implements Lesson  {

  CanvasElement canvas;
  Lesson003(this.canvas);

  final String vertexPositionAttribute = "aVertexPosition";
  final String colorVariable = "uColor";

  void start() {
    canvas.parent.rect.then((ElementRect rect) {
      canvas.width = 800;
      canvas.height = 800;

      WebGLRenderingContext gl = canvas.getContext('experimental-webgl');

      gl.viewport(0, 0, canvas.width, canvas.height);
      gl.clearColor(0, 0.5, 0, 1);
      gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT);

      String vertex = """
        attribute vec2 $vertexPositionAttribute;
          
        void main() {
          gl_Position = vec4($vertexPositionAttribute, 0.0, 1.0);
        }
      """;

      WebGLShader vs = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
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

      WebGLShader fs = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
      gl.shaderSource(fs, fragment);
      gl.compileShader(fs);

      WebGLProgram program = gl.createProgram();
      gl.attachShader(program, vs);
      gl.attachShader(program, fs);
      gl.linkProgram(program);

      if (!gl.getShaderParameter(vs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(vs));
      }

      if (!gl.getShaderParameter(fs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(fs));
      }

      if (!gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS)) {
        print(gl.getProgramInfoLog(program));
      }

      Float32Array vertices = new Float32Array.fromList(
          [
           -0.4, 0.6, 0.6, 0.6, 0.6, -0.4, // Triangle 1
           -0.6, 0.4, 0.4, -0.6, -0.6, -0.6 // Triangle 2
          ]);

      WebGLBuffer vbuffer = gl.createBuffer();
      gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, vbuffer);
      gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, vertices, WebGLRenderingContext.STATIC_DRAW);

      int itemSize = 2;
      int numItems = vertices.length ~/ itemSize;

      gl.useProgram(program);

      WebGLUniformLocation uColor = gl.getUniformLocation(program, colorVariable);
      gl.uniform4fv(uColor, new Float32Array.fromList([0.9, 0.3, 0.0, 0.5]));

      int aVertextPosition = gl.getAttribLocation(program, vertexPositionAttribute);
      gl.enableVertexAttribArray(aVertextPosition);
      gl.vertexAttribPointer(aVertextPosition, itemSize, WebGLRenderingContext.FLOAT, false, 0, 0);

      gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, numItems);
    });
  }
}


class Lesson004 implements Lesson  {

  CanvasElement canvas;
  Lesson004(this.canvas);

  final String attrVertex = "attrVertex";
  final String uPosition = "attrPosition";
  final String uColor = "uColor";

  void start() {
    canvas.parent.rect.then((ElementRect rect) {
      canvas.width = 800;
      canvas.height = 800;

      WebGLRenderingContext gl = canvas.getContext('experimental-webgl');

      gl.viewport(0, 0, canvas.width, canvas.height);
      gl.clearColor(0, 0, 0, 1);
      gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT);

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

      WebGLShader vs = gl.createShader(WebGLRenderingContext.VERTEX_SHADER);
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

      WebGLShader fs = gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);
      gl.shaderSource(fs, fragment);
      gl.compileShader(fs);

      WebGLProgram program = gl.createProgram();
      gl.attachShader(program, vs);
      gl.attachShader(program, fs);
      gl.linkProgram(program);

      if (!gl.getShaderParameter(vs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(vs));
      }

      if (!gl.getShaderParameter(fs, WebGLRenderingContext.COMPILE_STATUS)) {
        print(gl.getShaderInfoLog(fs));
      }

      if (!gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS)) {
        print(gl.getProgramInfoLog(program));
      }


      Float32Array vertices = new Float32Array.fromList(
          [
           0.5, 0.5, -0.5, 0.5, 0.5, -0.5, // Triangle 1
           -0.5, -0.5, -0.5, 0.5, 0.5, -0.5 // Triangle 2
          ]);

      WebGLBuffer squareBuffer = gl.createBuffer();
      gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, squareBuffer);
      gl.bufferData(WebGLRenderingContext.ARRAY_BUFFER, vertices, WebGLRenderingContext.STATIC_DRAW);

      int itemSize = 2;
      int numItems = vertices.length ~/ itemSize;

      gl.useProgram(program);

      WebGLUniformLocation varColor = gl.getUniformLocation(program, uColor);
      gl.uniform4fv(varColor, new Float32Array.fromList([0.9, 0.3, 0.0, 0.5]));

      WebGLUniformLocation varPosition = gl.getUniformLocation(program, uPosition);
      gl.uniform3fv(varPosition, new Float32Array.fromList([-1.5, 0, -7]));

      int aVertextPosition = gl.getAttribLocation(program, attrVertex);
      gl.enableVertexAttribArray(aVertextPosition);
      gl.vertexAttribPointer(aVertextPosition, itemSize, WebGLRenderingContext.FLOAT, false, 0, 0);

      gl.drawArrays(WebGLRenderingContext.TRIANGLES, 0, numItems);
    });
  }

}

