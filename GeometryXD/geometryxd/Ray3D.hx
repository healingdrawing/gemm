package geometryxd;

class Ray3D {
    
    /** internal property. 3D ray vector */
    var vec:Vec3D;
    
    /** internal property. 3D ray start dot */
    var sDot:Dot3D;
    
    /** internal usage of methods */
    var geo = new GeometryXD(false);
    
    
    /**
     * new 3D ray object
     * @param vec ray vector
     * @param sDot ray start dot
     */
    public function new(vec:Vec3D,?sDot:Dot3D) {
        this.vec = vec;
        this.sDot = (sDot!=null)? sDot : new Dot3D();
    }
    
    public function useDot() { }
    public function useDotArray() { }
    public function useVec() { }
    public function useVecArray() { /**ray direction**/ }
    
    public function fromDot() { }
    public function fromDotArray() { }
    public function fromVec() { }
    public function fromVecArray() { /**new ray direction**/ }
    
    public function valueDot() { return this.sDot.value(); }
    public function valueVec() { return this.vec.value(); }
    public function value() { return [valueVec(),valueDot()]; }
    
    /**
     * start dot of ray
     */
    public function s() {
        return this.sDot;
    }
    
    /**
     * vector of ray
     */
    public function v() {
        return this.vec;
    }
    
    /**
     * rotate ray around axis to angle
     * @param axis rotation axis
     * @param angle rotation angle
     * @param cDot rotation center 3D dot. if present then ray start 3D dot will be rotated too, around cDot
     */
    public function rotate(axis:Vec3D, angle:Angle, ?cDot:Dot3D) {
        this.vec.rotate(axis,angle);
        if (cDot != null) this.sDot.rotate(axis,angle,cDot);
    }
    
    /**
     * offset ray along vector to distance
     * @param v offset vector
     * @param d offset distance
     */
    public function offset(v:Vec3D, d:Float) {
        this.sDot.offset(v,d);
    }
    
    /**
     * scale ray start dot coordinates, relative to the scale center dot. Default is ray direction vector will not changed
     * @param sxyz scales for axes `[sx,sy,sz]`
     * @param cDot scale center dot
     * @param full scale ray direction vector too. Default is false (ray direction  will not changed). Scale center is `[0,0,0]`
     */
    public function scale(sxyz:Array<Float>, ?cDot:Dot3D, full = false) {
        this.sDot.scale(sxyz,(cDot!=null)?cDot:new Dot3D(geo.cxyz));
        if (full) this.vec.scale(sxyz);
    }
    
    /**
     * dot coordinates on ray
     * @param d displacement from ray start dot, along ray vector
     */
    public function dotArray(d:Float) { return geo.dotXDoffset(this.sDot.value(), this.vec.value(),d); }
    
    /**
     * dot object on ray
     * @param d displacement from ray start dot, along ray vector
     * @param mode 0-distance 1-x 2-y 3-z coordinates on ray
     */
    public function dot(d:Float) {
        return new Dot3D(geo.dotXDoffset(this.sDot.value(), this.vec.value(),d));
    }
    
    /** new 3D ray object, with same data. */
    public function copy() { return new Ray3D(this.vec, this.sDot); }
}