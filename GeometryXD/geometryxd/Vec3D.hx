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
    
    var am = new AM();
    
    /**
     * array of vec coordinates `[x,y,z]`
     */
    public function value() {
        return [this.x,this.y,this.z];
    }
    /**
     * number or vec dimensions
     */
    public function dn() {
        return this.value().length;
    }
    
    /**
     * array of mirrored values of vec coordinates. If `value()` = `[1,2,3]` return `[-1,-2,-3]`
     */
    public function valueM(){
        return am.minus_F(this.value());
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
     * new 3D vec object with mirrored coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,-2,-3]`
     */
    public function vec3DM() {
        return new Vec3D(new Dot3D(-this.x,-this.y,-this.z));
    }
    
    /**
     * new 3D vec object with mirrored x coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[-1,2,3]`
     */
    public function vec3DMx() {
        return new Vec3D(new Dot3D(-this.x,this.y,this.z));
    }
    
    /**
     * new 3D vec object with mirrored y coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,-2,3]`
     */
    public function vec3DMy() {
        return new Vec3D(new Dot3D(this.x,-this.y,this.z));
    }
    
    /**
     * new 3D vec object with mirrored z coordinate. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,2,-3]`
     */
    public function vec3DMz() {
        return new Vec3D(new Dot3D(this.x,this.y,-this.z));
    }
    
    /**
     * new 3D vec object with same coordinates. if `value()` = `[1,2,3]` return vec3DM().value() = `[1,2,3]`
     */
    public function vec3Dcopy(){
        return new Vec3D(new Dot3D(this.x,this.y,this.z));
    }
    
}
