package geometryxd;

class DotXD{
    var value:Array<Float>;
    
    /**
     * new multidimentional dot object.
     * @param dotXD - array of dot coordinates
     */
    public function new(dotXD:Array<Float>) {
        value = dotXD;
    }
    
    //public static function maxabs(a:Array<Float>):Float last before geometry functions section
    
    function oposite():Array<Float>{return GeometryXD.minus_F(value);}
}

class Dot3D{
    var x:Float;
    var y:Float;
    var z:Float;
    var value:Array<Float>;
    
    /**
     * new 3D dot object.
     * @param dot3D - array of dot coordinates `[x,y,z]`
     */
     public function new(dot3D:Array<Float>) {
        x = dot3D[0]; y=dot3D[1]; z=dot3D[2];
        value = [x,y,z];
    }
    
    function oposite():Array<Float>{return GeometryXD.minus_F(value);}
}
