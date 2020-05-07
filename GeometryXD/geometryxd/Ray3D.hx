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
    public function useVec() { }
    public function useArray() { /**ray direction**/ }
    
    public function fromDot() { }
    public function fromVec() { }
    public function fromArray() { /**new ray direction**/ }
    
    public function valueDot() { }
    public function valueVec() { }
    
    public function valueDotM() { }
    public function valueVecM() { }
    
    public function fromDotM() { }
    public function fromVecM() { }
    public function fromFullM() { }
    
    
    
    
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
        this.vec.useArray(geo.dot3Drotate(this.vec.value(),geo.cxyz,axis.value(),angle.deg()));
        if (cDot != null) this.sDot.useArray(geo.dot3Drotate(this.sDot.value(),cDot.value(),axis.value(),angle.deg()));
    }
    
    /**
     * offset ray along vector to distance
     * @param v offset vector
     * @param d offset distance
     */
    public function offset(v:Vec3D, d:Float) {
        this.sDot.useArray(geo.dotXDoffset(this.sDot.value(),v.value(),d));
    }
    
    /**
     * scale ray start dot coordinates, relative to the scale center dot. Default is ray direction vector will not changed
     * @param sxyz scales for axes `[sx,sy,sz]`
     * @param cDot scale center dot
     * @param full scale ray direction vector too. Default is false (ray direction  will not changed). Scale center is `[0,0,0]`
     */
    public function scale(sxyz:Array<Float>, ?cDot:Dot3D, full = false) {
        this.sDot.useArray(geo.dotXDscale(this.sDot.value(),sxyz,cDot.value()));
        if (full) this.vec.useArray(geo.dotXDscale(this.vec.value(),sxyz,[0,0,0]));
    }
    
    /**
     * dot on ray
     * @param d displacement from ray start dot, along ray vector
     */
    public function dot(d:Float) { return geo.dotXDoffset(this.sDot.value(), this.vec.value(),d); }
    
    
}