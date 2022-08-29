import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import fisica.*;

FWorld mundo;
Obstaculos o, o1;
FBox cuadradoBarras, cuadradoMulti, cuadradoInvisible;
int cuadradrosTamWidth = 50;
int cuadradrosTamHeight = 50;

Minim minim;
AudioPlayer arbitro, hinchada;
AudioSample pase;

float timerObs = 400;
float timerMultiply = 200;
float timerInvi = 200;

float obsY = 500;
float obsY1 = -500;
Personaje p1;
Pelota p, pow, pow1;
Villano p2;
Arcos a1, a2;
String estado = "inicio";
boolean goal = false;
int tiempoGol = 50;
boolean tiempoGola = false;
boolean enFestejo = false;
int gol, gol1;
PImage pelota, festejo;
PFont fuente;

boolean obs = false;
boolean power = false;

boolean tres = false;
boolean power1 = false;

boolean invisibilidad = false;
boolean power2 = false;


void setup() {

  size( 1200, 600 );
  Fisica.init(this);

  minim = new Minim(this);

  arbitro = minim.loadFile("Arbitro.mp3");
  pase = minim.loadSample("Pase pelota.mp3");
  hinchada = minim.loadFile("ambiente.mp3");

  pelota= loadImage("Pelota tejo.png");
  festejo= loadImage("Gol.png");
  fuente= loadFont("Evogria-48.vlw");
  textFont(fuente);

  gol = 0;
  gol1 = 0;

  mundo = new FWorld();
  mundo.setEdges(color(20));
  mundo.setGravity(0, 0);

  cuadradoBarras = new FBox(cuadradrosTamWidth, cuadradrosTamHeight);
  cuadradoBarras.setFill(0, 200, 0);
  cuadradoBarras.setName("boxBarras");
  cuadradoBarras.setNoStroke();
  cuadradoBarras.setSensor(true);
  cuadradoBarras.setPosition(-200, 0);
  mundo.add(cuadradoBarras);

  cuadradoMulti = new FBox(cuadradrosTamWidth, cuadradrosTamHeight);
  cuadradoMulti.setFill(0, 255, 0);
  cuadradoMulti.setName("boxMulti");
  cuadradoMulti.setNoStroke();
  cuadradoMulti.setSensor(true);
  cuadradoMulti.setPosition(-200, 0);
  mundo.add(cuadradoMulti);

  cuadradoInvisible = new FBox(cuadradrosTamWidth, cuadradrosTamHeight);
  cuadradoInvisible.setFill(0, 150, 0);
  cuadradoInvisible.setName("boxInvisible");
  cuadradoInvisible.setNoStroke();
  cuadradoInvisible.setSensor(true);
  cuadradoInvisible.setPosition(-200, 0);
  mundo.add(cuadradoInvisible);

  p = new Pelota(50);
  p.inicializar(width/2, height/2 );
  p.setName("circulo"); 
  mundo.add( p );

  p1 = new Personaje(80);
  p1.inicializar(100, height/2);
  mundo.add( p1 );

  p2 = new Villano(80);
  p2.inicializar(width-100, height/2);
  mundo.add( p2 );

  a1 = new Arcos( 10, 150 );
  a1.inicializar( 10, height/2, 255, 0, 0 );
  a1.setName("arco1");
  mundo.add( a1 );

  a2 = new Arcos( 10, 150 );
  a2.inicializar( width-10, height/2, 0, 0, 255 );
  a2.setName("arco2");
  mundo.add( a2 );

  o = new Obstaculos();
  o.inicializar( 200, 300, 50, height-50 );
  //mundo.add( o );

  o1 = new Obstaculos();
  o1.inicializar( width-200, width-300, 50, height-50 );
  //mundo.add( o1 );

  pow = new Pelota(50);
  pow.inicializar( p.getX(), p.getY() );
  pow.setName("circulo"); 
  //mundo.add( pow );

  pow1 = new Pelota(50);
  pow1.inicializar( p.getX(), p.getY() );
  pow1.setName("circulo"); 
  //mundo.add( pow1 );
}

void draw() {

  // -------------------------------------------------------------------------------
  //ESTADO INICIO

  if ( estado.equals("inicio") ) {
    textAlign( CENTER );
    textSize(50);
    background(0);
    fill(255);
    text( "PRESIONA ENTER PARA INICIAR", width/2, height/2 );
    if ( keyCode == ENTER ) {
      estado = "juego";
    }
  }

  // -------------------------------------------------------------------------------
  //ESTADO JUEGO

  if ( estado.equals("juego") || estado.equals("gol") ) {

    background(0, 100, 0);

    p1.actualizar();
    p2.actualizar();

    //Imagen pelota
    p.attachImage(pelota);

    arbitro.play();
    
    if (!hinchada.isPlaying()) {
      hinchada.rewind();
      hinchada.play();
    }

    if ( frameCount % 120 == 0 ) {
      cuadradoBarras.setPosition(-200, 0);
      cuadradoMulti.setPosition(-200, 0);
      cuadradoInvisible.setPosition(-200, 0);

      int random = int(random(0, 3));

      if (random == 1) {
        cuadradoBarras.setPosition(random(100, width-100), random(100, height-100));
      } else if (random == 2) {
        cuadradoMulti.setPosition(random(100, width-100), random(100, height-100));
      } else {
        cuadradoInvisible.setPosition(random(100, width-100), random(100, height-100));
      }
    }

    println( "Fps: " + frameRate );
    // -------------------------------------------------------------------------------
    //Obstaculos

    if ( obs ) {
      if ( power ) {
        mundo.add( o );
        mundo.add( o1 );
        power = false;
      }


      timerObs --;

      if ( o.getY() >= 544 ) {
        obsY = obsY*-1;
      } else if ( o.getY() <= 60 ) {
        obsY = obsY*-1;
      }
      if ( o.getY() >= 544 ) {
        obsY1 = obsY1*-1;
      } else if ( o.getY() <= 60 ) {
        obsY1 = obsY1*-1;
      }

      o.actualizar( obsY );
      o1.actualizar( obsY1 );

      if ( timerObs == 0 ) {
        mundo.remove( o );
        mundo.remove( o1 );
        timerObs = 400;
        obs = false;
      }
    }
    println( "timer" + timerInvi );

    // -------------------------------------------------------------------------------



    // -------------------------------------------------------------------------------
    //Multiplicación

    if ( tres ) {

      if ( power1 ) {
        mundo.add( pow );
        mundo.add( pow1 );
        pow.inicializar( p.getX()+100, p.getY()+100 );
        pow1.inicializar( p.getX()-100, p.getY()-100 );
        pow.attachImage(pelota);
        pow1.attachImage(pelota);
        pow.setVelocity( p.getVelocityX()+10, p.getVelocityY()+10 );
        pow1.setVelocity( p.getVelocityX()-10, p.getVelocityY()-10 );
        pow.setRestitution(1);
        pow1.setRestitution(0.8);
        power1 = false;
      }

      timerMultiply --;

      if ( timerMultiply == 0 ) {
        mundo.remove( pow );
        mundo.remove( pow1 );
        timerMultiply = 300;
        tres = false;
      }
    }


    // -------------------------------------------------------------------------------




    // -------------------------------------------------------------------------------
    //Invisibilidad

    if ( invisibilidad ) {

      if ( power2 ) {
       
        p.setFill(255, 0);
        pow.setFill(255, 0);
        pow1.setFill(255, 0);
        pelota = null; 
        power2 = false;
      }

      timerInvi --;

      if ( timerInvi == 0 ) {
       
        p.setFill(255, 0, 0);
        pow.setFill(255, 0, 0);
        pow1.setFill(255, 0, 0);
        timerInvi = 200;
        invisibilidad = false;
        pelota=loadImage("Pelota tejo.png"); 
      }
    }                          


    // -------------------------------------------------------------------------------



    // -------------------------------------------------------------------------------
    //ESTADO GOL && JUEGO
    p.setStatic(false);

    if ( tiempoGola == true ) {
      tiempoGol --;
      if ( tiempoGol > 0 ) {
        image(festejo, 40, 100);
      }
    }

    if ( tiempoGol == 0 ) {
      estado = "gol";
      goal = true;
      tiempoGol = 50;
      tiempoGola = false;
    }

    if ( estado.equals("gol") && goal == true ) {
      p.setVelocity( 0, 0 );
      p.inicializar(width/2, height/2 );
      goal = false;
      enFestejo = false;
      arbitro.rewind();
    }  

    text( gol, 100, 100 );
    text( gol1, width-100, 100 );

    //Linea mitad de cancha
    pushStyle();
    stroke(250);
    strokeWeight(3);
    line(width/2, -10, width/2, 650);
    popStyle();

    //Area chica y grande 
    pushStyle();
    ellipseMode(CENTER);
    strokeWeight(3);
    stroke(250);
    noFill();
    circle(600, 300, 200);

    rect(0, 160, 200, 280);
    rect(1010, 160, 200, 280);

    rect(0, 200, 90, 200);
    rect(1110, 200, 90, 200);
    popStyle();

    pushStyle();
    noStroke();
    circle(600, 300, 20);
    circle(150, 300, 20);
    circle(1060, 300, 20);
    popStyle();


    mundo.step();
    mundo.draw();
  }

  // -------------------------------------------------------------------------------


  // -------------------------------------------------------------------------------
  //ESTADO FIN

  if ( estado.equals("fin") ) {
    background( 0 );
    text( "Fin", width/2, height/2);
    text( "Presiona R para reiniciar", width/2, height/2+50);
    gol = 0;
    gol1 = 0;
    p.setVelocity( 0, 0 );
    p.inicializar(width/2, height/2 );
    p.setStatic(true);
    p1.inicializar(100, height/2);
    p2.inicializar(width-100, height/2);

    if ( key == 'r' && estado.equals("fin") ) {
      estado = "inicio";
      tiempoGol = 50;
      tiempoGola = false;
      goal = false;
      enFestejo = false;
      arbitro.rewind();
    }
  }

  // -------------------------------------------------------------------------------
}


// -------------------------------------------------------------------------------
//CONTACTOS

void contactStarted( FContact c) {
  FBody f1 = c.getBody1();
  FBody f2 = c.getBody2();

  //println( "c1 : " + f1.getName() );
  //println( "c2 : " + f2.getName() );
  //println( "tiempo de gol" + tiempoGol );

  if (f1.getName() == "circulo" && f2.getName() == "Personaje" || f1.getName() == "Personaje" && f2.getName() == "circulo" || f1.getName() == "circulo" && f2.getName() == "Malo" || f1.getName() == "Malo" && f2.getName() == "circulo") {
    pase.trigger();
  }

  if ((f1.getName() == "boxBarras" && f2.getName() == "Personaje" || f1.getName() == "Personaje" && f2.getName() == "boxBarras" || f1.getName() == "boxBarras" && f2.getName() == "Malo" || f1.getName() == "Malo" && f2.getName() == "boxBarras") && !obs && !power) {
    obs = true;
    power = true;
  }

  if ((f1.getName() == "boxMulti" && f2.getName() == "Personaje" || f1.getName() == "Personaje" && f2.getName() == "boxMulti" || f1.getName() == "boxMulti" && f2.getName() == "Malo" || f1.getName() == "Malo" && f2.getName() == "boxMulti") && !tres && !power1) {
    tres = true;
    power1 = true;
  }

  if ((f1.getName() == "boxInvisible" && f2.getName() == "Personaje" || f1.getName() == "Personaje" && f2.getName() == "boxInvisible" || f1.getName() == "boxInvisible" && f2.getName() == "Malo" || f1.getName() == "Malo" && f2.getName() == "boxInvisible") && !invisibilidad && !power2) {
    invisibilidad = true;
    power2 = true;
  }

  if ( (f1.getName() == "circulo" && f2.getName() == "arco1" || f1.getName() == "arco1" && f2.getName() == "circulo") && !enFestejo ) {
    gol1 ++;
    tiempoGola = true;
    enFestejo = true;

    mundo.remove( pow );
    mundo.remove( pow1 );
    timerMultiply = 200;
    tres = false;

    mundo.remove( o );
    mundo.remove( o1 );
    timerObs = 400;
    obs = false;
  } 

  if ( (f1.getName() == "circulo" && f2.getName() == "arco2" || f1.getName() == "arco2" && f2.getName() == "circulo") && !enFestejo ) {
    gol ++;
    tiempoGola = true;
    enFestejo = true;

    mundo.remove( pow );
    mundo.remove( pow1 );
    timerMultiply = 200;
    tres = false;

    mundo.remove( o );
    mundo.remove( o1 );
    timerObs = 400;
    obs = false;
  } 

  if ( gol == 3 || gol1 == 3 ) {
    estado = "fin";
  }
}

void keyPressed() {
  if ( key == 'w' ) {
    p1.upPress = true;
  }
  if ( key == 's' ) {
    p1.unPress = true;
  }
  if ( key == 'd' ) {
    p1.derPress = true;
  }
  if ( key == 'a' ) {
    p1.izqPress = true;
  }




  if ( keyCode == UP ) {
    p2.upPress = true;
  }
  if ( keyCode == DOWN ) {
    p2.unPress = true;
  }
  if ( keyCode == RIGHT ) {
    p2.derPress = true;
  }
  if ( keyCode == LEFT ) {
    p2.izqPress = true;
  }

  if ( key == 'c' ) {
    obs = true;
    power = true;
  }

  if ( key == 'v' ) {
    tres = true;
    power1 = true;
  }

  if ( key == 'b' ) {
    invisibilidad = true;
    power2 = true;
  }
}

void keyReleased() {

  if ( key == 'w' ) {
    p1.upPress = false;
  }
  if ( key == 's' ) {
    p1.unPress = false;
  }
  if ( key == 'd' ) {
    p1.derPress = false;
  }
  if ( key == 'a' ) {
    p1.izqPress = false;
  }



  if ( keyCode == UP ) {
    p2.upPress = false;
  }
  if ( keyCode == DOWN ) {
    p2.unPress = false;
  }
  if ( keyCode == RIGHT ) {
    p2.derPress = false;
  }
  if ( keyCode == LEFT ) {
    p2.izqPress = false;
  }

  if ( key == 'c' ) {
    power = false;
  }

  if ( key == 'v' ) {
    power1 = false;
  }

  if ( key == 'b' ) {
    power2 = false;
  }
}
