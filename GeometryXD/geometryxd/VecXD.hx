package geometryxd;

/**
 * multidimensional vector object
 */
 class VecXD{
    /**
     * internal property. array of vector coordinates
     */
    var coordinates:Array<Float>;
    
    /**
     * new multidimentional vector object. Both dots must have same dimensions number, or dotXDb will returned
     * @param dotXDb end multidimensional dot of vector
     * @param dotXDa start multidimensional dot of vector. Default will be `[0,...,0]`
     */
    public function new(dotXDb:DotXD, ?dotXDa:DotXD) {
       this.coordinates = (dotXDa != null && am.same_size_F([dotXDb.value,dotXDa.value])) ? am.diff_xF([dotXDb.value,dotXDa.value]) : dotXDb.value;
    }
    
    
    /**
     * set vector coordinates properties using array of coordinates.
     * @param coordinates array of XD vector coordinates `[x,y,...,z]`
     */
     public function useArray(coordinates:Array<Float>) {
        this.coordinates = coordinates;
    }
    
    /**
     * new VecXD object from array of coordinates.
     * @param coordinates array of multidimensional vector coordinates `[x,y,...,z]`
     */
    public function fromArray(coordinates:Array<Float>) {
        return vd(coordinates);
    }
    
    
    var am = new AM();
    
    public function value() {
        return this.coordinates;
    }
    
    /**
     * number of vector dimensions
     */
    public function dn() {
        return this.value().length;
    }
    
    /**
     * array of mirrored values of vector coordinates. If `value` = `[1,2,3,-4]` return `[-1,-2,-3,4]`
     */
    public function valueM(){
        return am.minus_F(this.value());
    }
    
    
    /**
     * internal function. Return VecXD object from multidimensional dot coordinates
     * @param c multidimensional dot coordinates array `[x,y,...,z]`
     */
     inline function vd(c:Array<Float>) {
        return new VecXD(new DotXD(c));
    }
    
    /**
     * new multidimensional vector object with mirrored coordinates. If `value` = `[1,2,3,-4]` return vecXD().value = `[-1,-2,-3,4]`
     */
     public function vecXDM(){
        return vd(valueM());
    }
    
    /**
     * new multidimensional vector object with same coordinates. if `value` = `[1,2,3,-4]` return vecXD().value = `[1,2,3,-4]`
     */
     public function vecXDcopy(){
        return vd(value());
    }
    
}
