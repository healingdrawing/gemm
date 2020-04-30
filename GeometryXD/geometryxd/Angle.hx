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
        return this.value;
        }
    
    /**
     * get angle value as `multiples of Math.PI`
     */
    public function mulp() {
        return this.value * 2;
    }
    
    /**
     * get angle value as `quadrant`
     */
    public function quad() {
        return this.value * 4;
    }
    
    /**
     * get angle value as `sextant`
     */
    public function sext() {
        return this.value * 6;
    }
    
    /**
     * get angle value as `radian`
     */
    public function rad() {
        return this.value * 2 * Math.PI;
    }
    
    /**
     * get angle value as `hexacontade`
     */
    public function hexa() {
        return this.value * 60;
    }
    
    /**
     * get angle value as `binary degree`
     */
    public function bdeg() {
        return this.value * 256;
    }
    
    /**
     * get angle value as `degree`
     */
    public function deg() {
        return this.value * 360;
    }
    
    /**
     * get angle value as `grad`
     */
    public function grad() {
        return this.value * 400;
    }
    
    /**
     * get angle value as `minute of arc`
     */
    public function marc() {
        return this.value * 21600;
    }
    
    /**
     * get angle value as `second of arc`
     */
    public function sarc() {
        return this.value * 1296000;
    }
    
    //plus minus value section for each unit variant
    
    //plus minus obj section
    
}
