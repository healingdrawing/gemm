package geometryxd;

/**
 * multidimensional vector object
 */
 class VecXD{
    /**
     * array of vector coordinates
     */
    public var value:Array<Float>;
    
    /**
     * new multidimentional vector object. Both dots must have same dimensions number, or dotXDb will returned
     * @param dotXDb end multidimensional dot of vector
     * @param dotXDa start multidimensional dot of vector. Default will be `[0,...,0]`
     */
    public function new(dotXDb:DotXD, ?dotXDa:DotXD) {
       this.value = (dotXDa != null && am.same_size_F([dotXDb.value,dotXDa.value])) ? am.diff_xF([dotXDb.value,dotXDa.value]) : dotXDb.value;
    }
    
    var am = new AM();
    
    /**
     * number of vector dimensions
     */
    public function dn() {
        return this.value.length;
    }
    
    /**
     * array of mirrored values of vector coordinates. If `value` = `[1,2,3,-4]` return `[-1,-2,-3,4]`
     */
    public function valueM(){
        return am.minus_F(this.value);
    }
    
    /**
     * new multidimensional vector object with mirrored coordinates. If `value` = `[1,2,3,-4]` return vecXD().value = `[-1,-2,-3,4]`
     */
     public function vecXDM(){
        return new VecXD(new DotXD(am.minus_F(this.value)));
    }
    
    /**
     * new multidimensional vector object with same coordinates. if `value` = `[1,2,3,-4]` return vecXD().value = `[1,2,3,-4]`
     */
     public function vecXDcopy(){
        return new VecXD(new DotXD(this.value));
    }
    
}
