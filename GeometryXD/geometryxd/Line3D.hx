package geometryxd;

/**
 * 3D line object
 */
class Line3D{
    
    /** internal property. Line end dot */
    var eDot:Dot3D;
    
    /** internal property. Line start dot */
    var sDot:Dot3D;
    
    /**
     * new 3D line object.
     * @param eDot 3D line end dot
     * @param sDot 3D line start dot . Default will `[0,0,0]`
     */
    public function new(eDot:Dot3D, ?sDot:Dot3D) {
        this.eDot = eDot;
        this.sDot = (sDot != null)? sDot : new Dot3D();
    }
    
    /** internal usage of methods */
    var geo = new GeometryXD(false);
    
    
}