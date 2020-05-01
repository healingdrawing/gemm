package geometryxd;

/**
 * multidimensional dot object
 */
class DotXD{
    /**
     * array of dot coordinates
     */
    public var coordinates:Array<Float>;
    
    /**
     * new multidimentional dot object.
     * @param dotXD - array of dot coordinates
     */
     public function new(dotXD:Array<Float>) {
        this.coordinates = dotXD;
    }
    
    
    /**
     * set multidimensional dot coordinates properties using array of coordinates.
     * @param coordinates array of multidimensional dot coordinates `[x,y,...,z]`
     */
     public function useArray(coordinates:Array<Float>) {
        this.coordinates = coordinates;
    }
    
    /**
     * new DotXD object from array of coordinates.
     * @param coordinates array of multidimensional dot coordinates `[x,y,...,z]`
     */
    public function fromArray(coordinates:Array<Float>) {
        return new DotXD(coordinates);
    }
    
    
    
    /**
     * internal usage of methods
     */
     var geo = new GeometryXD(false);
    
    
    /**
     * number or dot dimensions
     */
    public function dn() {
        return this.value().length;
    }
    
    
    public function value() {
        return this.coordinates;
    }
    
    /**
     * array of mirrored values of dot coordinates. If `value` = `[1,2,3,-4]` return `[-1,-2,-3,4]`
     */
    public function valueM(){
        return geo.am.minus_F(this.value());
    }
    
    /**
     * new multidimensional dot object with mirrored coordinates. If `value` = `[1,2,3,-4]` return dotXD().value = `[-1,-2,-3,4]`
     */
     public function dotXDM(){
        return new DotXD(geo.am.minus_F(this.value()));
    }
    
    /**
     * new multidimensional dot object with same coordinates. if `value` = `[1,2,3,-4]` return dotXD().value = `[1,2,3,-4]`
     */
     public function copy(){
        return new DotXD(this.value());
    }
    
}
