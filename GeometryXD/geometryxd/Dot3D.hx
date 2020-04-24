package geometryxd;

/**
 * 3D dot object
 */
class Dot3D{
    /**
     * x coordinate of dot
     */
    var x:Float;
    /**
     * y coordinate of dot
     */
    var y:Float;
    /**
     * z coordinate of dot
     */
    var z:Float;
    
    /**
     * new 3D dot object.
     * @param x coordinate of dot
     * @param y coordinate of dot
     * @param z coordinate of dot
     */
    public function new(x:Float, y:Float, z:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
     * array of dot coordinates `[x,y,z]`
     */
    var value(get,never):Array<Float>;
    function get_value() {
        return [this.x,this.y,this.z];
    }
    /**
     * number or dot dimensions
     */
    public var dn(get,never):Int;
    function get_dn() {
        return this.value.length;
    }
    
    /**
     * array of mirrored values of dot coordinates. If `value` = `[1,2,3]` then `valueM` = `[-1,-2,-3]`
     */
    public var valueM(get,never):Array<Float>;
    function get_valueM(){
        return GeometryXD.minus_F(value);
    }
    
    /**
     * array of values of dot coordinates with mirrored x coordinate. If `value` = `[1,2,3]` then `valueMx` = `[-1,2,3]`
     */
    public var valueMx(get,never):Array<Float>;
    function get_valueMx() {
        return [-this.x,this.y,this.z];
    }
    
    /**
     * array of values of dot coordinates with mirrored y coordinate. If `value` = `[1,2,3]` then `valueMx` = `[1,-2,3]`
     */
    public var valueMy(get,never):Array<Float>;
    function get_valueMy() {
        return [this.x,-this.y,this.z];
    }
    
    /**
     * array of values of dot coordinates with mirrored z coordinate. If `value` = `[1,2,3]` then `valueMx` = `[1,2,-3]`
     */
    public var valueMz(get,never):Array<Float>;
    function get_valueMz() {
        return [this.x,this.y,-this.z];
    }
    
    /**
     * new 3D dot object with mirrored coordinates. if this.value = `[1,2,3]` then dot3DM().value = `[-1,-2,-3]`
     */
    public var dot3DM(get,never):Dot3D;
    function get_dot3DM() {
        return new Dot3D(this.x,this.y,this.z);
    }
    
    /**
     * new 3D dot object with mirrored x coordinate. if this.value = `[1,2,3]` then dot3DM().value = `[-1,2,3]`
     */
    public var dot3DMx(get,never):Dot3D;
    function get_dot3DMx() {
        return new Dot3D(-this.x,this.y,this.z);
    }
    
    /**
     * new 3D dot object with mirrored y coordinate. if this.value = `[1,2,3]` then dot3DM().value = `[1,-2,3]`
     */
    public var dot3DMy(get,never):Dot3D;
    function get_dot3DMy() {
        return new Dot3D(this.x,-this.y,this.z);
    }
    
    /**
     * new 3D dot object with mirrored z coordinate. if this.value = `[1,2,3]` then dot3DM().value = `[1,2,-3]`
     */
    public var dot3DMz(get,never):Dot3D;
    function get_dot3DMz() {
        return new Dot3D(this.x,this.y,-this.z);
    }
    
}