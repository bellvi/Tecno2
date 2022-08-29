class Arcos extends FBox{
  
  
  Arcos( float x_, float h_){
    super( x_, h_ );
    setStatic(true);
    setGrabbable(false);
  }
  
  void inicializar( float x_, float y_, float a, float b, float c){
    setPosition( x_, y_ );
    setFill( a,b,c );
    
  }

  
}
