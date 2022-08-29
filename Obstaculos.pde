class Obstaculos extends FBox {

  int linea = 100;

  Obstaculos() {
    super( 20, 100 );
  }

  void inicializar(float x, float x1, float y, float y1) {

    setPosition( random( x, x1 ), random( y, y1 ) );
    setDensity( 500000 );
    setFill( 0, 255, 0 );
    setRotatable(false);
    //setStatic(true);
    setGrabbable(false);
  }

  void actualizar( float y ) {
    setVelocity( getVelocityX(), y);
  }
}
