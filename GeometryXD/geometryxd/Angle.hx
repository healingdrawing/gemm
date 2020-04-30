package geometryxd;

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
     * new angle object with few unit of measurement functionality. Created new instance angle value is 0.
     */
    public function new() {
        this.value = 0;
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
    public function sinh() { var a = rad(); return (Math.exp(a) - Math.exp(-a))/2; }
    /** hyperbolic cosine of angle */
    public function cosh() { var a = rad(); return (Math.exp(a) + Math.exp(-a))/2; }
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
    
    //plus minus value section for each unit variant
    
    //plus minus obj section
    
}
