package geometryxd;

/**
 * 3D vector object
 */
 class Vec3D{
    /**
     * x coordinate of vec
     */
    public var x:Float;
    /**
     * y coordinate of vec
     */
    public var y:Float;
    /**
     * z coordinate of vec
     */
    public var z:Float;
    
    /**
     * internal usage of methods
     */
    var geo = new GeometryXD(false);
    
    /**
     * new 3D vector object
     * @param dot3Db end 3D dot of vector
     * @param dot3Da start 3D dot of vector. Default will be `[0,0,0]`
     * @param xyz vector coordinates array. if not null, then used, and dot3Db, dot3Da will ignored. Wrong sized array will extended using zero's.
     */
    public function new(dot3Db:Dot3D, ?dot3Da:Dot3D, ?xyz:Array<Float>) {
        if (xyz!=null){
            if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
            this.x = xyz[0]; this.y = xyz[1]; this.z = xyz[2];
        }
        else if (dot3Da != null){
            this.x = dot3Db.x - dot3Da.x;
            this.y = dot3Db.y - dot3Da.y;
            this.z = dot3Db.z - dot3Da.z;
        }else{
            this.x = dot3Db.x;
            this.y = dot3Db.y;
            this.z = dot3Db.z;
        }
    }
    
    /**
     * number of vector dimensions
     */
     public function dn() {
        return 3;
    }
    
    /**
     * internal function. Return Vec3D object from 3D dot coordinates
     * @param c 3D dot coordinates array `[x,y,z]`
     */
     inline function vd(c:Array<Float>) {
        return new Vec3D(new Dot3D(c[0],c[1],c[2]));
    }
    
    /**
     * new Vec3D object from array of coordinates. Used first three array elements. Not enough length replaced uses 0.
     * @param xyz array of 3D vector coordinates `[x,y,z]`
     */
     public function fromArray(xyz:Array<Float>) {
        if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
        return vd(xyz);
    }
    
    
    /**
     * set `x,y,z` properties using array of coordinates. Used first three array elements. Not enough length replaced uses 0.
     * @param xyz array of 3D vector coordinates `[x,y,z]`
     */
    public function useArray(xyz:Array<Float>) {
        if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
        this.x = xyz[0];
        this.y = xyz[1];
        this.z = xyz[2];
    }
    
    /**
     * mirror 3D vector coordinates. `[1,2,3]` -> `[-1,-2,-3]`
     */
    public function useM() {
        this.x *= -1;
        this.y *= -1;
        this.z *= -1;
    }
    
    /**
     * mirror 3D vector x coordinate. `[1,2,3]` -> `[-1,2,3]`
     */
    public function useMx() {
        this.x *= -1;
    }
    
    /**
     * mirror 3D vector y coordinate. `[1,2,3]` -> `[1,-2,3]`
     */
    public function useMy() {
        this.y *= -1;
    }
    
    /**
     * mirror 3D vector z coordinate. `[1,2,3]` -> `[1,2,-3]`
     */
    public function useMz() {
        this.z *= -1;
    }
    
    /**
     * mirror 3D vector x y coordinates. `[1,2,3]` -> `[-1,-2,3]`
     */
    public function useMxy() {
        this.x *= -1;
        this.y *= -1;
    }
    
    /**
     * mirror 3D vector x z coordinates. `[1,2,3]` -> `[-1,2,-3]`
     */
    public function useMxz() {
        this.x *= -1;
        this.z *= -1;
    }
    
    /**
     * mirror 3D vector y z coordinates. `[1,2,3]` -> `[1,-2,-3]`
     */
    public function useMyz() {
        this.y *= -1;
        this.z *= -1;
    }
    
    /** scale vector length to value equal 1. Direction will not changed. */
    public function useOne() { useArray(geo.vecXDone(this.value())); }
    
    
    /**
     * array of vector coordinates `[x,y,z]`
     */
    public function value() {
        return [this.x,this.y,this.z];
    }
    
    /**
     * value of vector recounted to length equal 1
     */
    public function valueOne(){
        return geo.vecXDone(this.value());
    }
    
    /**
     * new 3D vector object, from data recounted to length equal 1
     */
    public function fromOne() {
        return vd(valueOne());
    }
    
    
    /**
     * rotate vector around axis to angle
     * @param axis rotation axis
     * @param angle rotation angle
     */
     public function rotate(axis:Vec3D, angle:Angle) {
        useArray(geo.vec3Drotate(value(),axis.value(),angle.deg()));
    }
    
    /**
     * scale vector coordinates, relative to the `[0,0,0]`.
     * @param sxyz scales for axes `[sx,sy,sz]`
     */
    public function scale(sxyz:Array<Float>) {
        useArray(geo.dotXDscale(value(),sxyz,geo.cxyz));
    }
    
    
    /**
     * new 3D vector object with same coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,2,3]`
     */
    public function copy(){
        return vd(value());
    }
    
}
