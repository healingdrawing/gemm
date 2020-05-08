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
     * internal usage of methods
     */
    var geo = new GeometryXD(false);
    
    /**
     * new 3D dot object.
     * @param x coordinate of dot
     * @param y coordinate of dot
     * @param z coordinate of dot
     * @param xyz dot coordinates array. if not null, then used, and x,y,z parameters will ignored. Wrong sized array will extended using zero's.
     */
    public function new(x:Float = 0, y:Float = 0, z:Float = 0, ?xyz:Array<Float>) {
        if (xyz!=null){
            if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
            x = xyz[0]; y = xyz[1]; z = xyz[2];
        }
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    /**
     * internal function. Return Dot3D object from 3D dot coordinates
     * @param c 3D dot coordinates array `[x,y,z]`
     */
     inline function dd(c:Array<Float>) {
        return new Dot3D(c[0],c[1],c[2]);
    }
    
    /**
     * new Dot3D object from array of coordinates. Used first three array elements. Not enough length replaced uses 0.
     * @param xyz array of 3D dot coordinates `[x,y,z]`
     */
     public function fromArray(xyz:Array<Float>) {
        if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
        return dd(xyz);
    }
    
    
    /**
     * set `x,y,z` properties using array of coordinates. Used first three array elements. Not enough length replaced uses 0.
     * @param xyz array of 3D dot coordinates `[x,y,z]`
     */
    public function useArray(xyz:Array<Float>) {
        if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
        this.x = xyz[0];
        this.y = xyz[1];
        this.z = xyz[2];
    }
    
    /**
     * mirror 3D dot coordinates. `[1,2,3]` -> `[-1,-2,-3]`
     */
    public function useM() {
        this.x *= -1;
        this.y *= -1;
        this.z *= -1;
    }
    
    /**
     * mirror 3D dot x coordinate. `[1,2,3]` -> `[-1,2,3]`
     */
    public function useMx() {
        this.x *= -1;
    }
    
    /**
     * mirror 3D dot y coordinate. `[1,2,3]` -> `[1,-2,3]`
     */
    public function useMy() {
        this.y *= -1;
    }
    
    /**
     * mirror 3D dot z coordinate. `[1,2,3]` -> `[1,2,-3]`
     */
    public function useMz() {
        this.z *= -1;
    }
    
    /**
     * mirror 3D dot x y coordinates. `[1,2,3]` -> `[-1,-2,3]`
     */
    public function useMxy() {
        this.x *= -1;
        this.y *= -1;
    }
    
    /**
     * mirror 3D dot x z coordinates. `[1,2,3]` -> `[-1,2,-3]`
     */
    public function useMxz() {
        this.x *= -1;
        this.z *= -1;
    }
    
    /**
     * mirror 3D dot y z coordinates. `[1,2,3]` -> `[1,-2,-3]`
     */
    public function useMyz() {
        this.y *= -1;
        this.z *= -1;
    }
    
    
    /**
     * number or dot dimensions
     */
     public function dn() {
        return 3;
    }
    
    
    /**
     * array of dot coordinates `[x,y,z]`
     */
    public function value() {
        return [this.x,this.y,this.z];
    }
    
    /**
     * new 3D dot object with same data.
     */
    public function copy(){
        return new Dot3D(this.x,this.y,this.z);
    }
    
}
