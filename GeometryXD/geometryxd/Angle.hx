package geometryxd;

enum abstract AngleUnit(Int){
    var None = 0;
    var Turn = 1;
    var Mulp = 2;
    var Quad = 3;
    var Sext = 4;
    var Rad = 5;
    var Hexa = 6;
    var Bdeg = 7;
    var Deg = 8;
    var Grad = 9;
    var Marc = 10;
    var Sarc = 11;
}

/**
 * Angle object with few unit of measurement functionality. Created new instance angle value is 0.
 * Internal storage unit is `turn`. Alternative names is `cyc`(circle), `rev`(revolution), `rot`(complete rotation).
 * 
 * set value methods available for units:
 * * useTurn(...) -> turn
 * * useMulp(...) -> `multiples of Math.PI`
 * * useQuad(...) -> `quadrant`
 * * useSext(...) -> `sextant`
 * * useRad(...) -> `radian`
 * * useHexa(...) -> `hexacontade`
 * * useBdeg(...) -> `binary degree`
 * * useDeg(...) -> `degree`
 * * useGrad(...) -> `grad`
 * * useMarc(...) -> `minute of arc`
 * * useSarc(...) -> `second of arc`
 * 
 * get value methods available for units:
 * * turn() -> turn
 * * mulp() -> `multiples of Math.PI`
 * * quad() -> `quadrant`
 * * sext() -> `sextant`
 * * rad() -> `radian`
 * * hexa() -> `hexacontade`
 * * bdeg() -> `binary degree`
 * * deg() -> `degree`
 * * grad() -> `grad`
 * * marc() -> `minute of arc`
 * * sarc() -> `second of arc`
 */
class Angle {
    
    /**
     * internal storage for base angle value, which unit is `turn`. 1 `turn` is 360 `deg` is one full rotation.
     * Alternative `turn` names is `cyc`(circle), `rev`(revolution), `rot`(complete rotation)
     */
    var value:Float;
    
    /**
     * internal usage of methods
     */
    var geo = new GeometryXD(false);
    
    
    /**
     * new angle object with few unit of measurement functionality. Created new instance angle default value is 0, default unit is `Turn`.
     * @param unit None = 0; Turn = 1; Mulp = 2; Quad = 3; Sext = 4; Rad = 5; Hexa = 6; Bdeg = 7; Deg = 8; Grad = 9; Marc = 10; Sarc = 11;
     * @param value 
     */
    public function new(?unit:AngleUnit, value:Float = 0) {
        switch unit{
            case Turn: useTurn(value);
            case Mulp: useMulp(value);
            case Quad: useQuad(value);
            case Sext: useSext(value);
            case Rad: useRad(value);
            case Hexa: useHexa(value);
            case Bdeg: useBdeg(value);
            case Deg: useDeg(value);
            case Grad: useGrad(value);
            case Marc: useMarc(value);
            case Sarc: useSarc(value);
            default: this.value = value;
        }
    }
    
    
    /**
     * set angle value.
     * @param angle incoming Angle object
     */
    public function useAngle(angle:Angle) {
        this.value = angle.value;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `turn`
     * @param value of angle
     */
    public function useTurn(value:Float) {
        this.value = value;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `multiples of Math.PI`
     * @param value of angle
     */
    public function useMulp(value:Float) {
        this.value = value / 2;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `quadrant`
     * @param value of angle
     */
    public function useQuad(value:Float) {
        this.value = value / 4;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `sextant`
     * @param value of angle
     */
    public function useSext(value:Float) {
        this.value = value / 6;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `radian`
     * @param value of angle
     */
    public function useRad(value:Float) {
        this.value = value / 2 / Math.PI;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `hexacontade`
     * @param value of angle
     */
    public function useHexa(value:Float) {
        this.value = value / 60;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `binary degree`
     * @param value of angle
     */
    public function useBdeg(value:Float) {
        this.value = value / 256;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `degree`
     * @param value of angle
     */
    public function useDeg(value:Float) {
        this.value = value / 360;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `grad`
     * @param value of angle
     */
    public function useGrad(value:Float) {
        this.value = value / 400;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `minute of arc`
     * @param value of angle
     */
    public function useMarc(value:Float) {
        this.value = value / 21600;
    }
    
    /**
     * set angle value. Incoming parameter angular unit is `second of arc`
     * @param value of angle
     */
    public function useSarc(value:Float) {
        this.value = value / 1296000;
    }
    
    // get value section
    
    /**
     * get angle value as `turn`
     */
     public function turn() {
        return value;
        }
    
    /**
     * get angle value as `multiples of Math.PI`
     */
    public function mulp() {
        return value * 2;
    }
    
    /**
     * get angle value as `quadrant`
     */
    public function quad() {
        return value * 4;
    }
    
    /**
     * get angle value as `sextant`
     */
    public function sext() {
        return value * 6;
    }
    
    /**
     * get angle value as `radian`
     */
    public function rad() {
        return value * 2 * Math.PI;
    }
    
    /**
     * get angle value as `hexacontade`
     */
    public function hexa() {
        return value * 60;
    }
    
    /**
     * get angle value as `binary degree`
     */
    public function bdeg() {
        return value * 256;
    }
    
    /**
     * get angle value as `degree`
     */
    public function deg() {
        return value * 360;
    }
    
    /**
     * get angle value as `grad`
     */
    public function grad() {
        return value * 400;
    }
    
    /**
     * get angle value as `minute of arc`
     */
    public function marc() {
        return value * 21600;
    }
    
    /**
     * get angle value as `second of arc`
     */
    public function sarc() {
        return value * 1296000;
    }
    
    //sin cos section
    /** trigonometric sine of angle */
    public function sin() { return Math.sin(rad()); }
    /** trigonometric cosine of angle */
    public function cos() { return Math.cos(rad()); }
    /** trigonometric tangent of angle */
    public function tan() { return Math.tan(rad()); }
    /** trigonometric cotangent of angle */
    public function cot() { return 1/tan(); }
    /** trigonometric secant of angle */
    public function sec() { return 1/cos(); }
    /** trigonometric cosecant of angle */
    public function csc() { return 1/sin(); }
    
    /** hyperbolic sine of angle */
    public function sinh() { return (Math.exp(rad()) - Math.exp(-rad()))/2; }
    /** hyperbolic cosine of angle */
    public function cosh() { return (Math.exp(rad()) + Math.exp(-rad()))/2; }
    /** hyperbolic tangent of angle */
    public function tanh() { return sinh()/cosh(); }
    /** hyperbolic cotangent of angle */
    public function coth() { return cosh()/sinh(); }
    /** hyperbolic secant of angle */
    public function sech() { return 1/cosh(); }
    /** hyperbolic cosecant of angle */
    public function csch() { return 1/sinh(); }
    
    //use sin cos section
    
    /** set angle value using trigonometric sine of angle 
     * @param v sine of angle
    */
    public function useSin(v:Float) { useRad( Math.asin(v) ); }
    /** set angle value using trigonometric cosine of angle 
     * @param v cosine of angle
    */
    public function useCos(v:Float) { useRad(Math.acos(v)); }
    /** set angle value using trigonometric tangent of angle 
     * @param v tangent of angle
    */
    public function useTan(v:Float) { useRad(Math.atan(v)); }
    /** set angle value using trigonometric cotangent of angle 
     * @param v cotangent of angle
    */
    public function useCot(v:Float) { useRad( Math.atan(v) + ((v<0)?Math.PI:0) ); }
    /** set angle value using trigonometric secant of angle 
     * @param v secant of angle
    */
    public function useSec(v:Float) { useRad(Math.acos(1/v)); }
    /** set angle value using trigonometric cosecant of angle 
     * @param v cosecant of angle
    */
    public function useCsc(v:Float) { useRad(Math.asin(1/v)); }
    
    /** set angle value using hyperbolic sine of angle 
     * @param v sine of angle
    */
    public function useSinh(v:Float) { useRad( Math.log( v + Math.sqrt(v*v + 1) ) ); }
    /** set angle value using hyperbolic cosine of angle 
     * @param v cosine of angle
    */
    public function useCosh(v:Float) { useRad( Math.log( v + Math.sqrt(v*v - 1) ) ); }
    /** set angle value using hyperbolic tangent of angle 
     * @param v tangent of angle
    */
    public function useTanh(v:Float) { useRad( 0.5 * Math.log( (1+v)/(1-v) ) ); }
    /** set angle value using hyperbolic cotangent of angle 
     * @param v cotangent of angle
    */
    public function useCoth(v:Float) { useRad( 0.5 * Math.log( (v+1)/(v-1) ) ); }
    /** set angle value using hyperbolic secant of angle 
     * @param v secant of angle
    */
    public function useSech(v:Float) { useRad( Math.log( 1/v + Math.sqrt(1/(v*v) - 1) ) ); }
    /** set angle value using hyperbolic cosecant of angle 
     * @param v cosecant of angle
    */
    public function useCsch(v:Float) { useRad( Math.log( 1/v + Math.sqrt(1/(v*v) + 1) ) ); }
    
    
    //from sin cos section
    
    /** new Angle object from trigonometric sine of angle 
     * @param v sine of angle
    */
    public function fromSin(v:Float) { return new Angle(Rad,(Math.asin(v))); }
    /** new Angle object from trigonometric cosine of angle 
     * @param v cosine of angle
    */
    public function fromCos(v:Float) { return new Angle(Rad,(Math.acos(v))); }
    /** new Angle object from trigonometric tangent of angle 
     * @param v tangent of angle
    */
    public function fromTan(v:Float) { return new Angle(Rad,(Math.atan(v))); }
    /** new Angle object from trigonometric cotangent of angle 
     * @param v cotangent of angle
    */
    public function fromCot(v:Float) { return new Angle(Rad,(Math.atan(v) + ((v<0)?Math.PI:0))); }
    /** new Angle object from trigonometric secant of angle 
     * @param v secant of angle
    */
    public function fromSec(v:Float) { return new Angle(Rad,(Math.acos(1/v))); }
    /** new Angle object from trigonometric cosecant of angle 
     * @param v cosecant of angle
    */
    public function fromCsc(v:Float) { return new Angle(Rad,(Math.asin(1/v))); }
    
    /** new Angle object from hyperbolic sine of angle 
     * @param v sine of angle
    */
    public function fromSinh(v:Float) { return new Angle(Rad,(Math.log( v + Math.sqrt(v*v + 1)))); }
    /** new Angle object from hyperbolic cosine of angle 
     * @param v cosine of angle
    */
    public function fromCosh(v:Float) { return new Angle(Rad,(Math.log( v + Math.sqrt(v*v - 1)))); }
    /** new Angle object from hyperbolic tangent of angle 
     * @param v tangent of angle
    */
    public function fromTanh(v:Float) { return new Angle(Rad,(0.5 * Math.log( (1+v)/(1-v)))); }
    /** new Angle object from hyperbolic cotangent of angle 
     * @param v cotangent of angle
    */
    public function fromCoth(v:Float) { return new Angle(Rad,(0.5 * Math.log( (v+1)/(v-1)))); }
    /** new Angle object from hyperbolic secant of angle 
     * @param v secant of angle
    */
    public function fromSech(v:Float) { return new Angle(Rad,(Math.log( 1/v + Math.sqrt(1/(v*v) - 1)))); }
    /** new Angle object from hyperbolic cosecant of angle 
     * @param v cosecant of angle
    */
    public function fromCsch(v:Float) { return new Angle(Rad,(Math.log( 1/v + Math.sqrt(1/(v*v) + 1)))); }
    
    //from unit section
    
    
    /**
     * new angle object using incoming angle object
     * @param value of angle
     */
     public function fromAngle(angle:Angle) { return new Angle(Turn,angle.turn()); }
    
    /**
     * new angle object. Incoming parameter angular unit is `turn`
     * @param value of angle
     */
     public function fromTurn(value:Float) { return new Angle(Turn,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `multiples of Math.PI`
     * @param value of angle
     */
    public function fromMulp(value:Float) { return new Angle(Mulp,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `quadrant`
     * @param value of angle
     */
    public function fromQuad(value:Float) { return new Angle(Quad,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `sextant`
     * @param value of angle
     */
    public function fromSext(value:Float) { return new Angle(Sext,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `radian`
     * @param value of angle
     */
    public function fromRad(value:Float) { return new Angle(Rad,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `hexacontade`
     * @param value of angle
     */
    public function fromHexa(value:Float) { return new Angle(Hexa,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `binary degree`
     * @param value of angle
     */
    public function fromBdeg(value:Float) { return new Angle(Bdeg,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `degree`
     * @param value of angle
     */
    public function fromDeg(value:Float) { return new Angle(Deg,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `grad`
     * @param value of angle
     */
    public function fromGrad(value:Float) { return new Angle(Grad,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `minute of arc`
     * @param value of angle
     */
    public function fromMarc(value:Float) { return new Angle(Marc,value); }
    
    /**
     * new angle object. Incoming parameter angular unit is `second of arc`
     * @param value of angle
     */
    public function fromSarc(value:Float) { return new Angle(Sarc,value); }
    
    
    //plus minus value section for each unit variant
    
    //plus minus obj section
    
}
