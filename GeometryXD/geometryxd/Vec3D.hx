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
    var geo = new GeometryXD();
    
    /**
     * new 3D vector object
     * @param dot3Db end 3D dot of vector
     * @param dot3Da start 3D dot of vector. Default will be `[0,0,0]`
     */
    public function new(dot3Db:Dot3D, ?dot3Da:Dot3D) {
        if (dot3Da != null){
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
     * new Vec3D object from array of coordinates. Used first three array elements. Not enough length replaced uses 0.
     * @param xyz array of 3D vector coordinates `[x,y,z]`
     */
    public function fromArray(xyz:Array<Float>) {
        if (xyz.length < 3) for (i in xyz.length ... 3) xyz.push(0);
        return vd(xyz);
    }
    
    
    /**
     * number of vector dimensions
     */
     public function dn() {
        return 3;
    }
    
    
    /**
     * array of vector coordinates `[x,y,z]`
     */
    public function value() {
        return [this.x,this.y,this.z];
    }
    
    /**
     * array of mirrored values of vec coordinates. If `value()` = `[1,2,3]` return `[-1,-2,-3]`
     */
    public function valueM(){
        return [-this.x,-this.y,-this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored x coordinate. If `value()` = `[1,2,3]` return `[-1,2,3]`
     */
    public function valueMx() {
        return [-this.x,this.y,this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored y coordinate. If `value()` = `[1,2,3]` return `[1,-2,3]`
     */
    public function valueMy() {
        return [this.x,-this.y,this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored z coordinate. If `value()` = `[1,2,3]` return `[1,2,-3]`
     */
    public function valueMz() {
        return [this.x,this.y,-this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored x y coordinates. If `value()` = `[1,2,3]` return `[-1,-2,3]`
     */
    public function valueMxy() {
        return [-this.x,-this.y,this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored x z coordinates. If `value()` = `[1,2,3]` return `[-1,2,-3]`
     */
    public function valueMxz() {
        return [-this.x,this.y,-this.z];
    }
    
    /**
     * array of values of vec coordinates with mirrored y z coordinates. If `value()` = `[1,2,3]` return `[1,-2,-3]`
     */
    public function valueMyz() {
        return [this.x,-this.y,-this.z];
    }
    
    
    /**
     * value of vector recounted to length equal 1
     */
    public function valueOne(){
        return geo.vecXDone(this.value());
    }
    
    /**
     * value of mirrored vector, recounted to length equal 1
     */
    public function valueOneM() {
        return geo.vecXDone(geo.vecXDback(this.value()));
    }
    
    /**
     * value of vector with mirrored x coordinate, recounted to length equal 1
     */
    public function valueOneMx() {
        return geo.vecXDone([-this.x,this.y,this.z]);
    }
    
    /**
     * value of vector with mirrored y coordinate, recounted to length equal 1
     */
    public function valueOneMy() {
        return geo.vecXDone([this.x,-this.y,this.z]);
    }
    
    /**
     * value of vector with mirrored z coordinate, recounted to length equal 1
     */
    public function valueOneMz() {
        return geo.vecXDone([this.x,this.y,-this.z]);
    }
    
    /**
     * value of vector with mirrored x y coordinates, recounted to length equal 1
     */
    public function valueOneMxy() {
        return geo.vecXDone([-this.x,-this.y,this.z]);
    }
    
    /**
     * value of vector with mirrored x z coordinates, recounted to length equal 1
     */
    public function valueOneMxz() {
        return geo.vecXDone([-this.x,this.y,-this.z]);
    }
    
    /**
     * value of vector with mirrored y z coordinates, recounted to length equal 1
     */
    public function valueOneMyz() {
        return geo.vecXDone([this.x,-this.y,-this.z]);
    }
    
    
    /**
     * internal function. Return Vec3D object from 3D dot coordinates
     * @param c 3D dot coordinates array `[x,y,z]`
     */
    inline function vd(c:Array<Float>) {
        return new Vec3D(new Dot3D(c[0],c[1],c[2]));
    }
    
    /**
     * new 3D vector object with mirrored coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,-2,-3]`
     */
    public function vec3DM() {
        return vd(valueM());
    }
    
    /**
     * new 3D vector object with mirrored x coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,2,3]`
     */
    public function vec3DMx() {
        return return vd(valueMx());
    }
    
    /**
     * new 3D vector object with mirrored y coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,-2,3]`
     */
    public function vec3DMy() {
        return vd(valueMy());
    }
    
    /**
     * new 3D vector object with mirrored z coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,2,-3]`
     */
    public function vec3DMz() {
        return vd(valueMz());
    }
    
    /**
     * new 3D vector object with mirrored x y coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,-2,3]`
     */
    public function vec3DMxy() {
        return vd(valueMxy());
    }
    
    /**
     * new 3D vector object with mirrored x z coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,2,-3]`
     */
    public function vec3DMxz() {
        return vd(valueMxz());
    }
    
    /**
     * new 3D vector object with mirrored y z coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,-2,-3]`
     */
    public function vec3DMyz() {
        return vd(valueMyz());
    }
    
    
    /**
     * new 3D vector object, recounted to length equal 1
     */
    public function vec3Done() {
        return vd(valueOne());
    }
    
    /**
     * new 3D vector object, with mirrored coordinates, recounted to length equal 1
     */
    public function vec3DoneM() {
        return vd(valueOneM());
    }
    
    /**
     * new 3D vector object, with mirrored x coordinate, recounted to length equal 1
     */
    public function vec3DoneMx() {
        return vd(valueOneMx());
    }
    
    /**
     * new 3D vector object, with mirrored y coordinate, recounted to length equal 1
     */
    public function vec3DoneMy() {
        return vd(valueOneMy());
    }
    
    /**
     * new 3D vector object, with mirrored z coordinate, recounted to length equal 1
     */
    public function vec3DoneMz() {
        return vd(valueOneMz());
    }
    
    /**
     * new 3D vector object, with mirrored x y coordinates, recounted to length equal 1
     */
    public function vec3DoneMxy() {
        return vd(valueOneMxy());
    }
    
    /**
     * new 3D vector object, with mirrored x z coordinates, recounted to length equal 1
     */
    public function vec3DoneMxz() {
        return vd(valueOneMxz());
    }
    
    /**
     * new 3D vector object, with mirrored y z coordinates, recounted to length equal 1
     */
    public function vec3DoneMyz() {
        return vd(valueOneMyz());
    }
    
    
    /**
     * new 3D vector object with same coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,2,3]`
     */
    public function vec3Dcopy(){
        return vd(value());
    }
    
}
