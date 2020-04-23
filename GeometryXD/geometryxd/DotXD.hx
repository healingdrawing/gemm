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
        return GeometryXD.minus_F(value);
    }
}

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
     * array of mirrored values of dot coordinates. If `value` = `[1,2,3,-4]` then `valueM` = `[-1,-2,-3,4]`
     */
    public var valueM(get,never):Array<Float>;
    function get_valueM(){
        return GeometryXD.minus_F(value);
    }
    
}

//public static function maxabs(a:Array<Float>):Float last before geometry functions section