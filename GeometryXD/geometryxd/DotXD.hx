package geometryxd;

/**
 * multidimensional dot object
 */
class DotXD{
    /**
     * array of dot coordinates
     */
    var value:Array<Float>;
    
    /**
     * new multidimentional dot object.
     * @param dotXD - array of dot coordinates
     */
     public function new(dotXD:Array<Float>) {
        value = dotXD;
    }
    
    /**
     * number or dot dimensions
     */
    public var dn(get,never):Int;
    function get_dn() {
        return this.value.length;
    }
    
    /**
     * array of mirrored values of dot coordinates. If `value` = `[1,2,3,-4]` then `valueM` = `[-1,-2,-3,4]`
     */
    public var valueM(get,never):Array<Float>;
    function get_valueM(){
        return AM.minus_F(value);
    }
    
}