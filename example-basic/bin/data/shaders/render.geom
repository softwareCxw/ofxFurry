#version 330 compatibility

#define VERT 3
#pragma include "helper.glsl"

layout(triangles) in;
layout(triangle_strip, max_vertices=6) out;

uniform mat4 viewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 modelMatrix;
uniform float time;
uniform float hairLeng;
uniform vec3 colors;
uniform int polygonTypes;
uniform vec2 collisionCoord;
                  
in VertexAttrib {
      vec3 normal;
      vec4 color;
} vertex[];

out vec4 vertex_color;
out vec3 dist;

void make_face(vec3 a, vec3 b, vec3 c, mat4 mvMatrix, mat4 mvpMatrix) {
    vec3 face_normal = normalize(cross(c - a, c - b));
    
    vertex_color = vec4(colors, 1.0);
    vec4 p1 = mvpMatrix * mvMatrix * vec4(a,1.0);
    p1.x+=snoise(vec2(2.5*p1.x*time,p1.y*time))*map(collisionCoord.x,0,1366,0.0,10.0);
    p1.y+=snoise(vec2(4.3*p1.y*time,p1.z*time))*map(collisionCoord.y,0,800,0.0,10.0);
    gl_Position = p1;
    EmitVertex();

    vertex_color = vec4(colors,1.0);
    vec4 p2 = mvpMatrix * mvMatrix * vec4(b,1.0);
    p2.x+=snoise(vec2(2.5*p2.x*time,p2.y*time));//collisionCoord.x;
    p2.y+=snoise(vec2(4.3*p2.y*time,p2.z*time));//collisionCoord.y;
    gl_Position = p2;
    EmitVertex();
    
    vertex_color = vec4(colors, 1.0) - snoise(vec2(c.x*time,c.y*time));
    vec4 p3 = mvpMatrix * mvMatrix *  vec4(c,1.0);
    p3.x+=snoise(vec2(2.5*p3.x*time,p3.y*time));
    p3.y+=snoise(vec2(4.3*p3.y*time,p3.z*time));
    gl_Position = p3;
    EmitVertex();
}

void polygonA(mat4 projectionMatrix, mat4 modelViewMatrix){
      vec3 a = vec3(gl_in[1].gl_Position - gl_in[0].gl_Position);
      vec3 b = vec3(gl_in[2].gl_Position - gl_in[0].gl_Position);
      vec3 center = vec3(gl_in[0].gl_Position + gl_in[1].gl_Position + gl_in[2].gl_Position) / 3.0;
      vec3 normal = normalize(cross(b, a));
      float t = hairLeng / float(VERT);
      
      for(int i=0; i<VERT; i++) {
         vertex_color = vec4(colors.x,colors.y,colors.z, 1.0);
         vec3 position = normal * map( t, 0., 1., 1.0, 500. ) + center;
         position.x += snoise(vec2(.6f*position.x,.2f*position.y) * time);
         position.y += snoise(vec2(.4f*position.y,.4f*position.z) * time);
         position.z += snoise(vec2(.2f*position.x,.6f*position.y) * time);
         gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
         EmitVertex();
      }
}

void polygonB(mat4 projectionMatrix, mat4 modelViewMatrix){
      vec3 stretch = vec3(hairLeng);
      vec3 a = gl_in[0].gl_Position.xyz;
      vec3 b = gl_in[1].gl_Position.xyz;
      vec3 c = gl_in[2].gl_Position.xyz;
      
      vec3 d = (a + b) * stretch;
      vec3 e = (b + c) * stretch;
      vec3 f = (c + a) * stretch;
      a *= (2.5 - stretch * rand(a.xy*hairLeng));
      b *= (5.5 - stretch * rand(b.xy*hairLeng));
      c *= (1.5 - stretch * rand(c.xy*hairLeng));
     
      make_face(a,d,f,modelViewMatrix,projectionMatrix);
      make_face(d,b,e,modelViewMatrix,projectionMatrix);
      make_face(e,c,f,modelViewMatrix,projectionMatrix);
      make_face(d,e,f,modelViewMatrix,projectionMatrix);
      /*vec3 a = vec3(gl_in[1].gl_Position - gl_in[0].gl_Position);
      vec3 b = vec3(gl_in[2].gl_Position - gl_in[0].gl_Position);
      vec3 center = vec3(gl_in[0].gl_Position + gl_in[1].gl_Position + gl_in[2].gl_Position) / 3.0;
      vec3 normal = normalize(cross(b, a));
      float t = hairLeng / float(VERT);
      
      for(int i=0; i<VERT; i++) {
         float ran = rand(vec2(hairLeng*time,time*hairLeng));
         
         vertex_color = vec4(colors.x,colors.y,colors.z, 1.0);
         vec3 position = normal * map( t, 0., 1., 1.0, 500. ) + center;
         position.x += snoise(vec2(.6f*position.x,.2f*position.y) * time);
         position.y += snoise(vec2(.4f*position.y,.4f*position.z) * time);
         position.z += snoise(vec2(.2f*position.x,.6f*position.y) * time);
         gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.0);
         EmitVertex();
         
         vertex_color = vec4(colors.z,colors.z,colors.z, 1.0);
         position = normal + map( t, 0., 1., 1.0, 200. ) + center;
         position.x += snoise(vec2(2.6f*position.x,4.2f*position.y) * time);
         position.y += snoise(vec2(2.4f*position.y,4.4f*position.z) * time);
         position.z += snoise(vec2(2.2f*position.x,4.6f*position.y) * time);
         gl_Position = projectionMatrix * modelViewMatrix * vec4(position,1.02);
         EmitVertex();
         }*/
}

void polygonC(mat4 projectionMatrix, mat4 modelViewMatrix) {
   vec3 a = vec3(gl_in[1].gl_Position - gl_in[0].gl_Position);
   vec3 b = vec3(gl_in[2].gl_Position - gl_in[0].gl_Position);
   vec3 normal = normalize(cross(b, a)) * hairLeng - 0.5;
   vec3 center = vec3(gl_in[0].gl_Position + gl_in[1].gl_Position + gl_in[2].gl_Position) / 3.0;
   float t = hairLeng / float(gl_in.length());

   vec4 view_pos = (vec4(normal,1.0)-.5) * vec4(center,1.0) - t;
   float tc = snoise(vec2(colors.x,colors.y))*snoise(vec2(colors.z,colors.y));
   vertex_color  = vec4(colors,1.0)-tc;
   view_pos.z   += snoise(vec2(view_pos.x*time,view_pos.y*time));
   gl_Position   = projectionMatrix * modelViewMatrix * view_pos;

   EmitVertex();
   
   view_pos = (vec4(normal,1.0)-.0042) * vec4(center,10.2) - (t);
   tc = snoise(vec2(colors.x,colors.y))*snoise(vec2(colors.y,colors.z));
   vertex_color  = vec4(0.,0.,0.,1.);
   view_pos.x   *= snoise(vec2(view_pos.z*time,view_pos.x*time));
   gl_Position   = projectionMatrix * modelViewMatrix * view_pos;

   EmitVertex();

}

void polygonD(){}
void polygonE(){}
void polygonF(){}

void main() {
   mat4 modelViewMatrix = viewMatrix * modelMatrix;
   mat4 viewProjectionMatrix = projectionMatrix * viewMatrix;
   //tessellation
   for(int i=0; i<VERT; i++) {
      vertex_color  = vec4(colors.x*snoise(vec2(colors.xy)),colors.y*snoise(vec2(colors.xy)),colors.z*snoise(vec2(colors.xy)),1.0);
      vec4 view_pos = modelViewMatrix * gl_in[i].gl_Position;
      gl_Position = projectionMatrix * view_pos;
      EmitVertex();
   }

   if(polygonTypes == 0){
      polygonA(projectionMatrix,modelViewMatrix);
   }
   
   if(polygonTypes == 1){
      polygonB(projectionMatrix,modelViewMatrix);
   }
   
   if(polygonTypes == 2){
      polygonC(projectionMatrix,modelViewMatrix);
   }
   
   if(polygonTypes == 3){
      //  polygonC(projectionMatrix,modelViewMatrix);
   }

   EndPrimitive();
}