package geometryxd;

class Ray3D {
    
    /** internal property. 3D ray vector */
    var vec:Vec3D;
    
    /** internal property. 3D ray start dot */
    var sDot:Dot3D;
    
    /**
     * new 3D ray object
     * @param vec ray vector
     * @param sDot ray start dot
     */
    public function new(vec:Vec3D,?sDot:Dot3D) {
        this.vec = vec;
        this.sDot = (sDot!=null)? sDot : new Dot3D();
    }
    
    
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
     * dot on ray
     * @param d displacement from ray start dot, along ray vector
     */
     public function dot(d:Float) {
         
    }
}