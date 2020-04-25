package geometryxd;

/**
 * multidimensional dot object
 */
class DotXD{
    /**
     * array of dot coordinates
     */
    public var value:Array<Float>;
    
    /**
     * new multidimentional dot object.
     * @param dotXD - array of dot coordinates
     */
     public function new(dotXD:Array<Float>) {
        this.value = dotXD;
    }
    
    var am = new AM();
    
    /**
     * number or dot dimensions
     */
    public function dn() {
        return this.value.length;
    }
    
    /**
     * array of mirrored values of dot coordinates. If `value` = `[1,2,3,-4]` return `[-1,-2,-3,4]`
     */
    public function valueM(){
        return am.minus_F(this.value);
    }
    
    /**
     * new multidimensional dot object with mirrored coordinates. If `value` = `[1,2,3,-4]` return dotXD().value = `[-1,-2,-3,4]`
     */
     public function dotXDM(){
        return new DotXD(am.minus_F(this.value));
    }
    
    /**
     * new multidimensional dot object with same coordinates. if `value` = `[1,2,3,-4]` return dotXD().value = `[1,2,3,-4]`
     */
     public function dotXDcopy(){
        return new DotXD(this.value);
    }
    
}
