package geometryxd;

/**
 * 3D dot object
 */
class Dot3D{
    /**
     * x coordinate of dot
     */
    public var x:Float;
    /**
     * y coordinate of dot
     */
    public var y:Float;
    /**
     * z coordinate of dot
     */
    public var z:Float;
    
    /**
     * new 3D dot object.
     * @param x coordinate of dot
     * @param y coordinate of dot
     * @param z coordinate of dot
     */
    public function new(x:Float = 0, y:Float = 0, z:Float = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    var geo = new GeometryXD();
    
    /**
     * array of dot coordinates `[x,y,z]`
     */
    public function value() {
        return [this.x,this.y,this.z];
    }
    /**
     * number or dot dimensions
     */
    public function dn() {
        return 3;
    }
    
    /**
     * array of mirrored values of dot coordinates. If `value()` = `[1,2,3]` return `[-1,-2,-3]`
     */
    public function valueM(){
        return [-this.x,-this.y,-this.z];
    }
    
    /**
     * array of values of dot coordinates with mirrored x coordinate. If `value()` = `[1,2,3]` return `[-1,2,3]`
     */
    public function valueMx() {
        return [-this.x,this.y,this.z];
    }
    
    /**
     * array of values of dot coordinates with mirrored y coordinate. If `value()` = `[1,2,3]` return `[1,-2,3]`
     */
    public function valueMy() {
        return [this.x,-this.y,this.z];
    }
    
    /**
     * array of values of dot coordinates with mirrored z coordinate. If `value()` = `[1,2,3]` return `[1,2,-3]`
     */
    public function valueMz() {
        return [this.x,this.y,-this.z];
    }
    
    /**
     * new 3D dot object with mirrored coordinates. if `value()` = `[1,2,3]` return dot3DM().value() = `[-1,-2,-3]`
     */
    public function dot3DM() {
        return new Dot3D(-this.x,-this.y,-this.z);
    }
    
    /**
     * new 3D dot object with mirrored x coordinate. if `value()` = `[1,2,3]` return dot3DM().value() = `[-1,2,3]`
     */
    public function dot3DMx() {
        return new Dot3D(-this.x,this.y,this.z);
    }
    
    /**
     * new 3D dot object with mirrored y coordinate. if `value()` = `[1,2,3]` return dot3DM().value() = `[1,-2,3]`
     */
    public function dot3DMy() {
        return new Dot3D(this.x,-this.y,this.z);
    }
    
    /**
     * new 3D dot object with mirrored z coordinate. if `value()` = `[1,2,3]` return dot3DM().value() = `[1,2,-3]`
     */
    public function dot3DMz() {
        return new Dot3D(this.x,this.y,-this.z);
    }
    
    /**
     * new 3D dot object with same coordinates. if `value()` = `[1,2,3]` return dot3DM().value() = `[1,2,3]`
     */
    public function dot3Dcopy(){
        return new Dot3D(this.x,this.y,this.z);
    }
    
}
