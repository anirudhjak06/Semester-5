//This Assignment is done by Anirudh Jakhotia
//Roll No : S20190010007

#include <GL/glew.h>
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

//Question 1) Bresenhams Line Algorithm.

int x, y, x2, y2;

void myInit() 
{
	glClear(GL_COLOR_BUFFER_BIT);
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glMatrixMode(GL_PROJECTION);
	gluOrtho2D(0, 500, 0, 500);
}

void drawpixel(int x, int y) 
{
	glBegin(GL_POINTS);
	glVertex2i(x, y);
	glEnd();
}

void drawline(int x, int x2, int y, int y2) 
{
	int dx, dy;
	int x11, y11;
	int dp, ddy, ddy_dx;
	dx = abs(x2 - x);
	dy = abs(y2 - y);
	dp = 2 * dy - dx;
	ddy = 2 * dy;

	ddy_dx = 2 * (dy - dx);
	drawpixel(x, y);

	while (x < x2)
	{
		x++;
		if (dp < 0)
		{
			drawpixel(x, y);
			dp += ddy;
		}
		else
		{
			y++;
			drawpixel(x, y);
			dp += ddy_dx;
		}
	}
}

void myDisplay() 
{
	drawline(x, x2, y, y2);
	glFlush();
}


//2nd and 3rd Question 
//Question 2- Triangle by sample triangle coverage using the methods discussed in the lecture.
//Question 3- Implement anti-aliasing using supersampling for triangle drawing.
void displayTriangle() 
{
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	glBegin(GL_TRIANGLES);
	glShadeModel(GL_FLAT);
	glVertex2f(-0.75, -0.75);
	glVertex2f(0.75, -0.75);
	glVertex2f(0, 0.75);
	glEnd();
	glutSwapBuffers();
}

int main(int argc, char** argv) 
{
    printf("Enter first point (x1,y1) : ");
    scanf("%d %d",&x,&y);
    printf("Enter second point (x2,y1) :");
    scanf("%d %d",&x2,&y2);

	//Question1-Bresemham's Line Drawing.
    glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(500, 500);
	glutInitWindowPosition(0, 0);
	glutCreateWindow("Bresenham's Line Drawing");
	myInit();
	glutDisplayFunc(myDisplay);

	//Question2- Triangle Sample Coverage
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
	glutInitWindowSize(500, 500);
	glutInitWindowPosition(100, 100);
	glutCreateWindow("Sample Triangle  coverage");
	glutDisplayFunc(displayTriangle);

	//Question3- Anti Aliasing using Super Sampling
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_MULTISAMPLE);
	glEnable(GL_MULTISAMPLE);
	glutInitWindowSize(500, 500);
	glutInitWindowPosition(200, 200);
	glutCreateWindow("Anti Aliasing using Super Sampling for Triangle");
	glutDisplayFunc(displayTriangle);
    glutMainLoop();
}