package geometryxd;

/**
 * number manipulation
 */
class NM{
    
    /**
     return sign of Int. if x < 0 return -1, else return 1.
     @param x - number, sign of which should be calculated
    **/
    public static inline function sign_I(x:Int):Int{ return (x < 0) ? -1 : 1; }
    /**
     return sign of Float. if x < 0 return -1, else return 1.
     @param x - number, sign of which should be calculated
    **/
    public static inline function sign_F(x:Float):Int{ return (x < 0) ? -1 : 1; }
    
    /**
     return sign of Int or 0. if x < 0 return -1, if x > 0 return 1, if x == 0 return 0.
     @param x - number, sign of which should be calculated
    **/
    public static inline function sign3_I(x:Int):Int{ return (x < 0) ? -1 : (x > 0) ? 1 : 0; }
    /**
     return sign of Float or 0. if x < 0 return -1, if x > 0 return 1, if x == 0 return 0.
     @param x - number, sign of which should be calculated
    **/
    public static inline function sign3_F(x:Float):Int{ return (x < 0) ? -1 : (x > 0) ? 1 : 0; }
    
    /**
     sin cos bonus function. Normalise sin cos, counted use vectors to -1...1 include boders.
     Need because sometimes (detected on python3 in the past) result of calculating sin cos
     uses vectors can be more then 1, or less then -1.
     For example 1.00000000001 etc. Just tiny correction, just for case.
     @param x - incoming sin cos value for check
    **/
    public static inline function sin_cos_cut(x:Float):Float { return (x>1)?1:(x<-1)?-1:x; }
    /**
     convert radians angle to degrees angle value
     @param angle - radians angle for recounting
    **/
    public static inline function degrees(angle:Float):Float { return angle * 180 / Math.PI; }
    /**
     convert degrees angle to radians angle value
     @param angle - degrees angle for recounting
    **/
    public static inline function radians(angle:Float):Float { return angle / 180 * Math.PI; }
    /**
     return the quadrant of any angle. 0 angle return 4 quadrant.
     For example use degrees:
     ... 0 < angle <= 90 return 1 quadrant 
     ... 90 < angle <= 180 return 2 quadrant 
     ... 180 < angle <= 270 return 3 quadrant 
     ... 270 < angle <= 360 return 4 quadrant 
     @param angle - angle for quadrant calculating
     @param rad - if true then radians angle, default false (degrees angle)
    **/
    public static function angle_quadrant(angle:Float, rad:Bool = false):Int {
        var k:Int=4; // 0 case
        if (rad){angle=degrees(angle);}
        var x:Float=angle%360;
        if (x > 270){ k = 4; }
        else if (x > 180){ k = 3; }
        else if (x > 90){ k = 2; }
        else if (x > 0){ k = 1; }
        else if (x <= -270){ k = 1; }
        else if (x <= -180){ k = 2; }
        else if (x <= -90){ k = 3; }
        else if (x <= 0){ k = 4; }
        return k;
    }
    
    
    /**
     split interval to equal steps
     @param xmin - minimum border
     @param xmax - maximum border
     @param n - steps number
     @param borders - if true then add borders into result
    **/
    public static inline function steps_internal(
        xmin:Float,
        xmax:Float,
        n:Int,
        borders:Bool = false
        ):Array<Float>{
        var rez:Array<Float> = null;
        if (n < 0){ return rez; }
        var st:Float = (xmax - xmin) / (n + 1);
        if (borders){
            rez = [for (i in 0...n + 2) (i > 0 && i < n + 1) ? xmin + st * i : (i == 0) ? xmin : xmax ];
        }else{
            rez = [for (i in 1...n + 1) xmin + st * i];
        }return rez;
    }
    /**
     repeat step multiple times.
     f(1, 5, 3, -1) return [-11, -7, -3, 1, 5]
     f(1, 5, 3, 0) return [-11, -7, -3, 1, 5, 9, 13, 17]
     f(1, 5, 3, 1) return [1, 5, 9, 13, 17]
     @param smin - step minimum border
     @param smax - step maximum border
     @param n - repeat number
     @param direction - if < 0 then from negative to minimum border direction. if > 0 then from maximum border to positive direction. if == 0 then both
    **/
    public static function steps_external(
        smin:Float,
        smax:Float,
        n:Int,
        direction:Int
        ):Array<Float>{
        var rez:Array<Float> = null;
        if (n < 1 || direction < -1 || direction > 1){ return rez; }
        var st:Float = smax - smin;
        if (direction > 0){
            rez = [for (i in 0...n + 2) smin + st * i ];
        }else if (direction < 0){
            var full:Float = smin - st * n;
            rez = [for (i in 0...n + 2) full + st * i ];
        }else{
            var full:Float = smin - st * n;
            rez = [for (b in 0...2) for (i in 0...n + 2) (b == 0) ? full + st * i : (i > 1) ? smin + st * i : continue];
        }return rez;
    }
    
    /**
     chain bonus function. split range to sequences specified length n with same border values.
     f(6, 3, false) return [[0, 1, 2], [2, 3, 4]]. But f(6, 3, true) return [[0, 1, 2], [2, 3, 4], [4, 5, 0]].
     Can be used to split dotsXDfield (array of 3D dots) to array of separated 4dots curves trajectories which have same border dots.
     Just split array of dots length a_l to n = 4. Then recount to beziercurves or create multidot curve use each last three dots.
     @param a_l - range of indexes (length of array which will be used later as splitted)
     @param n - length of each sequence (chain link)
     @param ring - if true then 0 will be added at the end of range of indexes, for the case of strict coincidence
    **/
    public static function chain_indexes(
        a_l:Int,
        n:Int,
        ring:Bool
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = null;
        if (n > a_l || n < 1){ return rez; }
        var ind:Array<Int> = [];
        var indring:Array<Int> = [for (i in 0...a_l) i];
        if(ring){
            indring.push(0);
            ind = [for (i in 0...Std.int((a_l + 1) / (n - 1)) * (n - 1) ) (i%(n-1) == 0 && i+n-1 < a_l + 1)? i : continue ]; // close to for loop(0 to a_l+1 with step=n)
        }else{
            ind = [for (i in 0...Std.int(a_l / (n - 1)) * (n - 1) ) (i%(n-1) == 0 && i+n-1 < a_l)? i : continue ]; // close to for loop(0 to a_l with step=n)
        }rez = [for (i in 0...ind.length) [for (j in 0...n) indring[ind[i]+j]] ];
        return rez;
    }
    
}