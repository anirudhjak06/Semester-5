//libraries to be included
#include<stdio.h>
#include<stdlib.h>
#include<GL/glut.h>
#include<math.h>
#include<time.h>
#include<windows.h>


//declaration of variables for rotation and translation
GLfloat Ambient_color[]={0.1,0.1,0.1,1.0};
GLfloat Diffuse_color[]={1.0,1.0,1.0,1.0};
GLfloat Specular_color[]={.50,.50,.50,.10};
GLfloat Black_color[]={0.0f,0.0f,0.0f,1.0f};
GLfloat White_color[]={1.0f,1.0f,1.0f,1.0f};
GLfloat Blue_color[]={0.0f,0.0f,0.9f,1.0f};
GLfloat Yellow_color[]={0.7f,0.2f,0.0f,1.0f};
GLfloat temp_color1[]={0,0,0,0.1};
GLfloat scale_array[8]={0.295 , 0.40,0.50, 0.60,0.80,1.0,1.05,1.13};
float Moon_rotate=0.0, Earth_rotate=0.0,Astroid_rotate=0.0,Mars_rotate=0.0,Mercury_rotate=0.0,Venus_rotate=0.0,Jupiter_rotate=0.0,Saturn_rotate=0.0,Uranus_rotate=30.0,Neptune_rotate=60.0;
GLfloat scale_x=0.2,scale_y=0.2,scale_z=0.2;
double rotation_deg=2*(3.14)/50;
double rotation_deg1=2*(3.14)/300;


//to specify the different lighting effects
void Light_initialize()
{
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT7);

    glLightfv(GL_LIGHT7,GL_AMBIENT,Ambient_color);
    glLightfv(GL_LIGHT7,GL_DIFFUSE,Diffuse_color);
    glLightfv(GL_LIGHT7,GL_SPECULAR,Specular_color);
    
}

void initialize_display()
{
   glClearColor(0.0,0.0,0.0,0.0); //backgroundcolor is green//glClearColor specifies the red, green, Blue_color, and alpha values used by glClear to clear the color buffers. xcs specified by glClearColor are clamped to the range 0 1
   glPointSize(1.0);
   glLineWidth(2.0);

}

void display_background()
{
    glBegin(GL_QUADS);
      glColor3f(0.0,0.00,0.00);
      glVertex3f(-01.00,01.00,1);
      glColor3f(.20,0.0,0.70);
      glVertex3f(01.00,1.00,1);
      glColor3f(0,0.0,0.0);
      glVertex3f(1.00,-1.00,1);
      glColor3f(.70,.10,.20);
      glVertex3f(-1.00,-1.00,1);
    glEnd();
}


void display_orbit()
{
glColor3f(0.5,0.5,0.5);


int i=0;
for(i=0;i<8;i++){
glPushMatrix();
if(i==5)
{
  glRotatef(45,1.0,0.0,0.0);
}
else
{
  glRotatef(63,1.0,0.0,0.0);
}

glScalef(scale_array[i],scale_array[i],scale_array[i]);
glBegin(GL_POINTS);

double rotation_deg2=0.0;
  int i=0;
  for(i=0;i<300;i++)
  {
    glVertex2d(cos(rotation_deg2),sin(rotation_deg2));
   rotation_deg2+=rotation_deg1;
     }

glEnd();
glPopMatrix();
}
}

void callback_planets(void)
{
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    display_background();
    display_orbit();
    glLoadIdentity();
    glPushMatrix();
    glEnable(GL_DEPTH_TEST);
   glEnable(GL_COLOR_MATERIAL);
       glPushMatrix();
       glColor3f(0.7,0.5,0.0);
       glScalef(scale_x,scale_y,scale_z);
        glLightfv(GL_LIGHT7,GL_POSITION,temp_color1);
       glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,Yellow_color);
       glutSolidSphere(1,50,50);
       glMaterialfv(GL_FRONT_AND_BACK,GL_EMISSION,Black_color);
       glPopMatrix();

       glScalef(0.2,0.2,0.2);
       glPushMatrix();
         glRotatef(Mercury_rotate,0.0,1.0,-0.5);
         glTranslatef(1.5,0.0,0.0);
         glColor3f(1.0,0.9,0.0);
         glScalef(0.08,0.08,0.08);
         glutSolidSphere(1,50,50);
       glPopMatrix();

       glPushMatrix();
         glRotatef(Venus_rotate,0.0,1.0,-0.5);
         glTranslatef(2.0,0.0,0.0);
         glColor3f(0.9,0.1,0.0);
         glScalef(0.1,0.1,0.1);
         glutSolidSphere(1,50,50);
       glPopMatrix();

       glPushMatrix();
         glRotatef(Earth_rotate,0.0,1.0,-0.5);
         glTranslatef(2.5,0.0,0.0);
         glColor3f(0.0,0.1,0.7);
         glScalef(0.23,0.23,0.23);
         glutSolidSphere(1,50,50);
            glPushMatrix();
             glRotatef(Moon_rotate,0.0,0.1,0.05);
             glTranslatef(1.3,0.0,0.0);
             glColor3f(1.0,1.0,1.0);
             glScalef(0.5,0.5,0.5);
             glutSolidSphere(0.5,50,50);
           glPopMatrix();
       glPopMatrix();
       glPushMatrix();
         glRotatef(Mars_rotate,0.0,1.0,-0.5);
         glTranslatef(-3.0,0.0,0.0);
         glColor3f(0.05,0.05,0.01);
         glScalef(0.17,0.17,0.17);
         glutSolidSphere(1,50,50);
       glPopMatrix();

        glPushMatrix();
             glColor3f(3.30,3.30,3.30);
             glRotatef(63,1.0,0.0,0.0);
             int j=0,i=0,rotate_d=90;float length=2;
             float scale_temp[4]={3.3,3.4,3.35,3.2};
             for(j=0;j<4;j++)
             {
               glPushMatrix();length-=0.3;
             glPointSize(length);
             glScalef(scale_temp[j],scale_temp[j],scale_temp[j]);
             glBegin(GL_POINTS);
                double rotation_deg2=0.0 -Astroid_rotate,a=(2*(3.14))/rotate_d;
                for(i=0;i<rotate_d;i++)
                  {glVertex2d(cos(rotation_deg2),sin(rotation_deg2));
                   rotation_deg2+=a;  
                   }
                   rotate_d+=10;
            glEnd();
            glPopMatrix();
             }
           glPopMatrix();

       glPushMatrix();
         glRotatef(Jupiter_rotate,0.0,1.0,-0.5);
         glTranslatef(-4.0,0.0,0.0);
         glColor3f(0.4,0.2,0.0);
         glScalef(0.5,0.5,0.5);
         glutSolidSphere(1,50,50);
         glPushMatrix();
             glRotatef(Moon_rotate,1.0,-0.5,0.0);
             glTranslatef(0.0,0,1.1);
             glColor3f(1.0,1.0,1.0);
             glScalef(0.1,0.1,0.1);
             glutSolidSphere(0.5,50,50);
           glPopMatrix();
       glPopMatrix();

       glPushMatrix();
         glRotatef(Saturn_rotate,0.0,1.0,-1.0);
         glTranslatef(-5.0,0.0,0.0);
         glColor3f(0.9,0.0,0.0);
         glScalef(0.4,0.4,0.4);
         glutSolidSphere(1,50,50);
         glPushMatrix();
             glRotatef(45,1.0,0.0,0.0);
             glPointSize(3);
             glColor3f(5.0,3.0,1.0);
             glScalef(1.2,1.2,1.2);
             glBegin(GL_POINTS);
                double rotation_deg2=0.0;
                i=0;
                for(i=0;i<50;i++)
                  {glVertex2d(cos(rotation_deg2),sin(rotation_deg2));
                   rotation_deg2+=rotation_deg;  }
            glEnd();

            glPointSize(2);
           glPopMatrix();
       glPopMatrix();

       glPushMatrix();
         glRotatef(Uranus_rotate,0.0,1.0,-0.5);
         glTranslatef(5.2,0.0,0.0);
         glColor3f(0.0,0.5,0.9);
         glScalef(0.23,0.23,0.23);
         glutSolidSphere(1,50,50);
       glPopMatrix();

       glPushMatrix();
         glRotatef(Neptune_rotate,0.0,1.0,-0.5);
         glTranslatef(-5.7,0.0,0.0);
         glColor3f(0.0,0.0,0.9);
         glScalef(0.2,0.2,0.2);
         glutSolidSphere(1,50,50);
       glPopMatrix();


glPopMatrix();
     glFlush();
}


void change_axis(int xc){

if((Moon_rotate>=0 && Moon_rotate<180) ){
  scale_x-=0.0003;scale_y-=0.0003;scale_z-=0.0003;
}
else{
  scale_x+=0.0003;scale_y+=0.0003;scale_z+=0.0003;
  }

Moon_rotate+=2;
if(Moon_rotate>360){
    Moon_rotate-=360;
    }

Earth_rotate+=0.7;
if(Earth_rotate>360){
    Earth_rotate-=360;
    }

Mercury_rotate+=2;
if(Mercury_rotate>360){
    Mercury_rotate-=360;
    }

Venus_rotate+=0.9;
if(Venus_rotate>360){
    Venus_rotate-=360;
    }

Mars_rotate+=0.5;
if(Mars_rotate>360){
    Mars_rotate-=360;
    }

Jupiter_rotate+=0.2;
if(Jupiter_rotate>360){
    Jupiter_rotate-=360;
    }

Saturn_rotate+=0.1;
if(Saturn_rotate>360){
    Saturn_rotate-=360;
    }


Uranus_rotate+=0.05;
if(Uranus_rotate>360){
    Uranus_rotate-=360;
    }


Neptune_rotate+=0.02;
if(Neptune_rotate>360){
    Neptune_rotate-=360;
    }


Astroid_rotate+=0.002;
if(Astroid_rotate>360){
    Astroid_rotate-=360;
    }


glutPostRedisplay();
glutTimerFunc(20,change_axis,0);

}

int main(int argc, char **argv)
{
    glutInit(&argc,argv);//glutInit is used to initialize the GLUT library. 
    glutInitDisplayMode(GLUT_SINGLE|GLUT_RGB);//glutInitDisplayMode() allows you to control the mode for subsequent OpenGLUT windows. Allowable displayMode is a combination of: - GLUT_RGB. Red, green, Blue_color framebuffer
    glutInitWindowPosition(0,0); //initial window position 
    glutInitWindowSize(700,700); //initial window size
    glutCreateWindow("Solar System"); //creates a window named "solar System" 
    Light_initialize(); //ambient diffuse and specular
    initialize_display();
    glutDisplayFunc(callback_planets);//glutDisplayFunc(void (*func)(void)) is the first and most important event callback function you will see. Whenever GLUT determines that the contents of the window need to be redisplayed, the callback function registered by glutDisplayFunc() is executed.
    glutTimerFunc(25,change_axis,0);
    glutMainLoop();
    return 0;
}