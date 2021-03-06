#include "ofMain.h"
#include "ofxGui.h"
#include "ofxAssimpModelLoader.h"
#include "ofxFurry.h"

class ofApp : public ofBaseApp{
        public:

        ofxAssimpModelLoader model;
        ofxFurry furry;
        ofEasyCam cam;
        ofxPanel gui;
        ofParameter<ofVec3f> translateA;
        ofParameter<ofVec3f> translateB;
        ofParameter<ofVec3f> translateC;
        ofParameter<ofVec3f> color;
        ofParameter<float> alpha;
        ofParameter<float> hairLeng;
        ofParameter<bool> noise;
        ofParameter<bool> tassellation;
        int w,h;

        void setup();
        void update();
        void draw();
        void keyPressed(int key);
};
