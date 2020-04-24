package geometryxd;

/**
 * array manipulation
 */
class AM{
    
    /**
      return true if incoming Int Array have at least one positive element
      @param a - incoming array
     **/
     public static inline function positive_inside_I(a:Array<Int>):Bool{
        for (i in a){ if (i > 0){ return true; } }
        return false;
    }
    /**
      return true if incoming Int Array have at least one zero element
      @param a - incoming array
     **/
    public static inline function zero_inside_I(a:Array<Int>):Bool{
        for (i in a){ if (i == 0){ return true; } }
        return false;
    }
    /**
      return true if incoming Int Array have at least one negative element
      @param a - incoming array
     **/
    public static inline function negative_inside_I(a:Array<Int>):Bool{
        for (i in a){ if (i < 0){ return true; } }
        return false;
    }
    /**
      return true if incoming Float Array have at least one positive element
      @param a - incoming array
     **/
    public static inline function positive_inside_F(a:Array<Float>):Bool{
        for (i in a){ if (i > 0){ return true; } }
        return false;
    }
    /**
      return true if incoming Float Array have at least one zero element
      @param a - incoming array
     **/
    public static inline function zero_inside_F(a:Array<Float>):Bool{
        var rez:Bool = false;
        for (i in a){ if (i == 0){ rez = true; } }
        return rez;
    }
    /**
      return true if incoming Float Array have at least one negative element
      @param a - incoming array
     **/
    public static inline function negative_inside_F(a:Array<Float>):Bool{
        var rez:Bool = false;
        for (i in a){ if (i < 0){ rez = true; } }
        return rez;
    }
    /**
      return true if Int Arrays have same size
      @param a - incoming arrays
     **/
    public static inline function same_size_I(a:Array<Array<Int>>):Null<Bool>{
        var rez:Null<Bool> = null;
        var al:Int = a.length;
        if (al > 1){
            rez = true;
            var size:Int = a[0].length;
            for (i in 1...al){
                if (size != a[i].length) { rez = false; break; }
            }
        }else{ rez  = true; }
        return rez;
    }
    /**
      return true if Float Arrays have same size
      @param a - incoming arrays
     **/
    public static inline function same_size_F(a:Array<Array<Float>>):Null<Bool>{
        var rez:Null<Bool> = null;
        var al:Int = a.length;
        if (al > 1){
            rez = true;
            var size:Int = a[0].length;
            for (i in 1...al){
                if (size != a[i].length) { rez = false; }
            }
        }else{ rez = true; }
        return rez;
    }
    
    /**
     compare Int Arrays. Returns true if all arrays have equal data
     @param a - incoming array field
    **/
    public static function same_xI(a:Array<Array<Int>>):Null<Bool>{
        var rez:Null<Bool> = null;
        var al:Int = a.length;
        if ( al > 0 && same_size_I(a) ){
            rez = true;
            var lv:Int = a[0].length;
            for (i in 1...al){
                for (j in 0...lv){
                    if(rez){ if (a[0][j] != a[i][j]) { rez = false; } }
                    else{ break; }
                }if (!rez){ break; }
            }
        }return rez;
    }
    /**
     compare Float Arrays. Returns true if all arrays have equal data
     @param a - incoming array field
    **/
    public static function same_xF(a:Array<Array<Float>>):Null<Bool>{
        var rez:Null<Bool> = null;
        var al:Int = a.length;
        if ( al > 0 && same_size_F(a) ){
            rez = true;
            var lv:Int = a[0].length;
            for (i in 1...al){
                for (j in 0...lv){
                    if(rez){ if (a[0][j] != a[i][j]) { rez = false; } }
                    else{ break; }
                }if (!rez){ break; }
            }
        }return rez;
    }
    
    /**
      returns sum of Int Array elements. [1,2,3] -> 6. tested
      @param a - incoming array
     **/
    public static inline function sum_I(a:Array<Int>):Null<Int>{
        var rez:Null<Int> = null;
        var al:Int = a.length;
        if (al > 0){ rez = 0; for (i in 0...al){ rez += a[i]; } }
        return rez;
    }
    /**
      returns sum of Float Array elements. [1.1,2,3] -> 6.1. tested
      @param a - incoming array
     **/
    public static inline function sum_F(a:Array<Float>):Null<Float>{
        var rez:Null<Float> = null;
        var al:Int = a.length;
        if (al > 0){ rez = 0; for (i in 0...al){ rez += a[i]; } }
        return rez;
    }
    /**
      returns diff between first and others Int Array elements. [1,2,3] -> -4. tested
      @param a - incoming array
     **/
    public static function diff_I(a:Array<Int>):Null<Int>{
        var rez:Null<Int> = null;
        var al:Int = a.length;
        if (al > 0){
            if (al == 1){ rez = a[0]; }
            else{ rez = a[0] - sum_I([for (i in 1...al) a[i]]); }
        }return rez;
    }
    /**
      returns diff between first and others Float Array elements. [1.1,2,3] -> -3.9. tested
      @param a - incoming array
     **/
    public static function diff_F(a:Array<Float>):Null<Float>{
        var rez:Null<Float> = null;
        var al:Int = a.length;
        if (al > 0){
            if (al == 1){ rez = a[0]; }
            else{ rez = a[0] - sum_F([for (i in 1...al) a[i]]); }
        }return rez;
    }
    /**
      returns middle value of Float Array
      @param a - incoming array
     **/
    public static function middle_F(a:Array<Float>):Null<Float>{
        var rez:Null<Float> = null;
        var al:Int = a.length;
        if (al > 0){ rez = sum_F(a) / al; }
        return rez;
    }
    /**
      multiplies each element of an Int Array by Int
      @param a - incoming array
      @param n - multiplier of each element
     **/
    public static inline function multiply_I_I(
        a:Array<Int>,
        n:Int
        ):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) a[i] * n]; }
        return rez;
    }
    /**
      multiplies each element of an Float Array by Float
      @param a - incoming array
      @param n - multiplier of each element
     **/
    public static inline function multiply_F_F(
        a:Array<Float>,
        n:Float
        ):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) a[i] * n]; }
        return rez;
    }
    /**
      multiplies all elements of an Int Array. [1, 2, 3] return 1 * 2 * 3
      @param a - incoming array
     **/
    public static inline function multiply_I(a:Array<Int>):Null<Int>{
        var rez:Null<Int> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = a[0];
            if (al>1){for(i in 1...al){ rez *= a[i]; }}
        }return rez;
    }
    /**
      multiplies all elements of an Float Array. [1.1, 2.0, 3.0] return 1.1 * 2.0 * 3.0
      @param a - incoming array
     **/
    public static inline function multiply_F(a:Array<Float>):Null<Float>{
        var rez:Null<Float> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = a[0];
            if (al>1){for(i in 1...al){ rez *= a[i]; }}
        }return rez;
    }
    /**
      multiplies each element of the Int Array by -1
      @param a - incoming array
     **/
    public static inline function minus_I(a:Array<Int>):Array<Int>{
        return [for (i in 0...a.length) -a[i]];
    }
    /**
      multiplies each element of the Float Array by -1
      @param a - incoming array
     **/
    public static inline function minus_F(a:Array<Float>):Array<Float>{
        return [for (i in 0...a.length) -a[i]];
    }
    
    /**
      return Int Array which is Int Arrays sum. [[1, 2, 3], [-3, -2, -1]] return [-2, 0, 2]
      @param a - incoming arrays
     **/
    public static function sum_xI(a:Array<Array<Int>>):Array<Int>{
        var rez:Array<Int> = null;
        if ( same_size_I(a) ){ rez = [for (i in 0...a[0].length) sum_I([for (ai in 0...a.length) a[ai][i] ]) ]; }
        return rez;
    }
    /**
      return Float Array which is Float Arrays sum. [[1.1, 2, 3], [-3, -2, -1]] return [-1.9, 0, 2]
      @param a - incoming arrays
     **/
    public static function sum_xF(a:Array<Array<Float>>):Array<Float>{
        var rez:Array<Float> = null;
        if ( same_size_F(a) ){ rez = [for (i in 0...a[0].length) sum_F([for (ai in 0...a.length) a[ai][i] ]) ]; }
        return rez;
    }
    /**
      return Int Array which is result of diff between first Int Array and others. [[1, 2, 3], [-3, -2, -1]] return [4, 4, 4]
      @param a - incoming arrays
     **/
    public static function diff_xI(a:Array<Array<Int>>):Array<Int>{
        var rez:Array<Int> = null;
        if ( same_size_I(a) ){ rez = [for (i in 0...a[0].length) diff_I([for (ai in 0...a.length) a[ai][i] ]) ]; }
        return rez;
    }
    /**
      return Float Array which is result of diff between first Float Array and others. [[1.1, 2, 3], [-3, -2, -1]] return [4.1, 4, 4]
      @param a - incoming arrays
     **/
    public static function diff_xF(a:Array<Array<Float>>):Array<Float>{
        var rez:Array<Float> = null;
        if ( same_size_F(a) ){ rez = [for (i in 0...a[0].length) diff_F([for (ai in 0...a.length) a[ai][i] ]) ]; }
        return rez;
    }
    /**
      return Float Array with middle values from arrays. [[1.1, 2, 3], [-3, -2, -1]] return [(1.1 - 3) / 2, (2 - 2) / 2, (3 - 1) / 2]
      @param a - incoming arrays
     **/
    public static function middle_xF(a:Array<Array<Float>>):Array<Float>{
        var rez:Array<Float> = null;
        if (a[0].length > 0 && same_size_F(a) ){ rez = [for (i in 0...a[0].length) middle_F([for (ai in 0...a.length) a[ai][i] ]) ]; }
        return rez;
    }
    /**
      return Int arrays which is result of multiplying each element by Int
      @param a - incoming arrays
      @param n - multiplier
     **/
    public static function multiply_xI_I(
        a:Array<Array<Int>>,
        n:Int
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = null;
        if ( a.length > 0 ){ rez = [for (i in 0...a.length) multiply_I_I(a[i], n) ]; }
        return rez;
    }
    /**
      return Float arrays which is result of multiplying each element by Float
      @param a - incoming arrays
      @param n - multiplier
     **/
    public static function multiply_xF_F(
        a:Array<Array<Float>>,
        n:Float
        ):Array<Array<Float>>{
        var rez:Array<Array<Float>> = null;
        if ( a.length > 0 ){ rez = [for (i in 0...a.length) multiply_F_F(a[i], n) ]; }
        return rez;
    }
    /**
      return Int Array which is result of multiplying arrays. [[1, 2], [3, 4]] return [1 * 3, 2 * 4]
      @param a - incoming arrays
     **/
    public static function multiply_xI(a:Array<Array<Int>>):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if(same_size_I(a)){
            if (al > 1){
                rez = [for (i in 0...a[0].length) multiply_I([for (ai in 0...a.length) a[ai][i] ]) ];
            }else if (al > 0){
                rez = a[0];
            }
        }return rez;
    }
    /**
      return Float Array which is result of multiplying arrays. [[3.1, 2], [3, 4]] return [3.1 * 3, 2 * 4]
      @param a - incoming arrays
     **/
    public static function multiply_xF(a:Array<Array<Float>>):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (same_size_F(a)){
            if (al > 1){
                rez = [for (i in 0...a[0].length) multiply_F([for (ai in 0...a.length) a[ai][i] ]) ];
            }else if (al > 0){
                rez = a[0];
            }
        }return rez;
    }
    /**
      Int Arrays bonus function. Short form of sum_I(multiply_xI(a)). [[a, b], [c, d]] return a * c + b * d
      @param a - incoming arrays
     **/
    public static function multisum_xI(a:Array<Array<Int>>):Null<Int>{
        var rez:Null<Int> = null;
        if (
            a.length > 1 &&
            a[0].length > 0 &&
            same_size_I(a)
        ){
            rez = sum_I(multiply_xI(a));
        }
        return rez;
    }
    /**
      Float Arrays bonus function. Short form of sum_F(multiply_xF(a)). [[a, b], [c, d]] return a * c + b * d
      @param a - incoming arrays
     **/
    public static function multisum_xF(a:Array<Array<Float>>):Null<Float>{
        var rez:Null<Float> = null;
        if (
            a.length > 1 &&
            a[0].length > 0 &&
            same_size_F(a)
        ){
            rez = sum_F(multiply_xF(a));
        }
        return rez;
    }
    /**
      return Int Array which is result of sum with previous element. [1, 2, 3] return [1, 3, 5]
      @param a - incoming array
     **/
    public static inline function sum_previous_I(a:Array<Int>):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) (i == 0) ? a[i] : a[i] + a[i - 1]]; }
        return rez;
    }
    /**
      return Int Array which is result of diff with previous element. [1, 2, 3] return [1, 1, 1]
      @param a - incoming array
     **/
    public static inline function diff_previous_I(a:Array<Int>):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) (i == 0) ? a[i] : a[i] - a[i - 1]]; }
        return rez;
    }
    /**
      return Int Array which is result of sum each element with before elements sum. [1, 2, 3] return [1, 3, 6]
      @param a - incoming array
     **/
    public static inline function sum_before_I(a:Array<Int>):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = [0];
            for (i in 0...al){
                rez.push( rez[rez.length - 1] + a[i] );
            }rez.shift();
        }return rez;
    }
    /**
      return Int Array which is result of diff each element with before elements diff. [1, 2, 3] return [1, 1, 2]
      @param a - incoming array
     **/
    public static inline function diff_before_I(a:Array<Int>):Array<Int>{
        var rez:Array<Int> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = [0];
            for (i in 0...al){
                rez.push( a[i] - rez[rez.length - 1] );
            }rez.shift();
        }return rez;
    }
    /**
      return Float Array which is result of sum with previous element. [1.1, 2, 3] return [1.1, 3.1, 5]
      @param a - incoming array
     **/
    public static inline function sum_previous_F(a:Array<Float>):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) (i == 0) ? a[i] : a[i] + a[i - 1]]; }
        return rez;
    }
    /**
      return Float Array which is result of diff with previous element. [1.1, 2, 3] return [1.1, 0.9, 1]
      @param a - incoming array
     **/
    public static inline function diff_previous_F(a:Array<Float>):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (al > 0){ rez = [for (i in 0...al) (i == 0) ? a[i] : a[i] - a[i - 1]]; }
        return rez;
    }
    /**
      return Float Array which is result of sum each element with before elements sum. [1.1, 2, 3] return [1.1, 3.1, 6.1]
      @param a - incoming array
     **/
    public static inline function sum_before_F(a:Array<Float>):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = [0];
            for (i in 0...al){
                rez.push( rez[rez.length - 1] + a[i] );
            }rez.shift();
        }return rez;
    }
    /**
      return Float Array which is result of diff each element with before elements diff. [1.1, 2, 3] return [1.1, 0.9, 2.1]
      @param a - incoming array
     **/
    public static inline function diff_before_F(a:Array<Float>):Array<Float>{
        var rez:Array<Float> = null;
        var al:Int = a.length;
        if (al > 0){
            rez = [0];
            for (i in 0...al){
                rez.push( a[i] - rez[rez.length - 1] );
            }rez.shift();
        }return rez;
    }
    
    /**
     recount Int Array to Float Array
     @param what - incoming array
    **/
    public static inline function recounter_I_F(what:Array<Int>):Array<Float>{
        var rez:Array<Float> = [];
        for (i in 0...what.length){ rez.push(what[i]); }
        return rez;
    }
    /**
     recount Float Array to Int Array
     @param what - incoming array
    **/
    public static inline function recounter_F_I(what:Array<Float>):Array<Int>{
        var rez:Array<Int> = [];
        for (i in 0...what.length){ rez.push(Std.int(what[i])); }
        return rez;
    }
    /**
     recount Int Array to String Array
     @param what - incoming array
    **/
    public static inline function recounter_I_S(what:Array<Int>):Array<String>{
        var rez:Array<String> = [];
        for (i in 0...what.length){ rez.push(Std.string(what[i])); }
        return rez;
    }
    /**
     recount Float Array to String Array
     @param what - incoming array
    **/
    public static inline function recounter_F_S(what:Array<Float>):Array<String>{
        var rez:Array<String> = [];
        for (i in 0...what.length){ rez.push(Std.string(what[i])); }
        return rez;
    }
    /**
     recount String Array to Int Array
     @param what - incoming array
    **/
    public static inline function recounter_S_I(what:Array<String>):Array<Int>{
        var rez:Array<Int> = [];
        for (i in 0...what.length){ rez.push(Std.parseInt(what[i])); }
        return rez;
    }
    /**
     recount String Array to Float Array
     @param what - incoming array
    **/
    public static inline function recounter_S_F(what:Array<String>):Array<Float>{
        var rez:Array<Float> = [];
        for (i in 0...what.length){ rez.push(Std.parseFloat(what[i])); }
        return rez;
    }
    
    /**
     repeat Float Array to specified length
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static inline function repeater_F_F(
        n:Int,
        what:Array<Float>,
        full:Bool = false
        ):Array<Float>{
        var rez:Array<Float> = null;
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat Int Array to specified length
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static inline function repeater_I_I(
        n:Int,
        what:Array<Int>,
        full:Bool = false
        ):Array<Int>{
        var rez:Array<Int> = null;
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat String Array to specified length
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static inline function repeater_S_S(
        n:Int,
        what:Array<String>,
        full:Bool = false
        ):Array<String>{
        var rez:Array<String> = null;
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat Float Array to specified length Int Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_F_I(
        n:Int,
        what_:Array<Float>,
        full:Bool = false
        ):Array<Int>{
        var rez:Array<Int> = null;
        var what:Array<Int> = recounter_F_I(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat String Array to specified length Int Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_S_I(
        n:Int,
        what_:Array<String>,
        full:Bool = false
        ):Array<Int>{
        var rez:Array<Int> = null;
        var what:Array<Int> = recounter_S_I(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat Int Array to specified length Float Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_I_F(
        n:Int,
        what_:Array<Int>,
        full:Bool = false
        ):Array<Float>{
        var rez:Array<Float> = null;
        var what:Array<Float> = recounter_I_F(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat String Array to specified length Float Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_S_F(
        n:Int,
        what_:Array<String>,
        full:Bool = false
        ):Array<Float>{
        var rez:Array<Float> = null;
        var what:Array<Float> = recounter_S_F(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat Int Array to specified length String Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_I_S(
        n:Int,
        what_:Array<Int>,
        full:Bool = false
        ):Array<String>{
        var rez:Array<String> = null;
        var what:Array<String> = recounter_I_S(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    /**
     repeat Float Array to specified length String Array
     @param n - result array length
     @param what - incoming array
     @param full - if true then result array will be not cutted to result array length parameter
    **/
    public static function repeater_F_S(
        n:Int,
        what_:Array<Float>,
        full:Bool = false
        ):Array<String>{
        var rez:Array<String> = null;
        var what:Array<String> = recounter_F_S(what_);
        if (n == 0){ return rez; }
        var wl:Int = what.length;
        rez = [];
        if (wl == 0){ return rez; }
        if (n < 0){ what.reverse(); n = Std.int(Math.abs(n));}
        var ind:Int =(full) ? n : Math.ceil(n / wl);
        rez = [for (_ in 0...ind) for (i in 0...wl) what[i]];
        if(!full){rez = [for (i in 0...n) rez[i]]; }
        return rez;
    }
    
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=["1", "2"] b=["1", "2", "1"] return [[0, 0], [0, 2], [1, 1]]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_b_S(
        a:Array<String>,
        b:Array<String>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                if (a[ia] == b[ib]) { rez.push([ia, ib]); }
            }
        }return rez;
    }
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=["1", "2"] b=[["1", "2", "1"],["0", "2"]] return [[0, 0, 0], [0, 0, 2], [1, 0, 1], [1, 1, 1]]. where indexes [1, 0, 1] = [1(a), 0(b), 1(b[0])]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_bn_S(
        a:Array<String>,
        b:Array<Array<String>>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                for (ibn in 0...b[ib].length){
                    if (a[ia] == b[ib][ibn]) { rez.push([ia, ib, ibn]); }
                }
            }
        }return rez;
    }
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=[1, 2] b=[1, 2, 1] return [[0, 0], [0, 2], [1, 1]]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_b_I(
        a:Array<Int>,
        b:Array<Int>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                if (a[ia] == b[ib]) { rez.push([ia, ib]); }
            }
        }return rez;
    }
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=[1, 2] b=[[1, 2, 1],[0, 2]] return [[0, 0, 0], [0, 0, 2], [1, 0, 1], [1, 1, 1]]. where indexes [1, 0, 1] = [1(a), 0(b), 1(b[0])]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_bn_I(
        a:Array<Int>,
        b:Array<Array<Int>>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                for (ibn in 0...b[ib].length){
                    if (a[ia] == b[ib][ibn]) { rez.push([ia, ib, ibn]); }
                }
            }
        }return rez;
    }
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=[1.0, 2.0] b=[1.0, 2.0, 1.0] return [[0, 0], [0, 2], [1, 1]]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_b_F(
        a:Array<Float>,
        b:Array<Float>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                if (a[ia] == b[ib]) { rez.push([ia, ib]); }
            }
        }return rez;
    }
    /**
     return array of arrays with pair indexes which is indexes equivalent elements of a and b arrays.
     a=[1.0, 2.0] b=[[1.0, 2.0, 1.0],[0, 2.0]] return [[0, 0, 0], [0, 0, 2], [1, 0, 1], [1, 1, 1]]. where indexes [1, 0, 1] = [1(a), 0(b), 1(b[0])]
     @param a - array what find
     @param b - array where find
    **/
    public static inline function an_in_bn_F(
        a:Array<Float>,
        b:Array<Array<Float>>
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = [];
        var al:Int = a.length;
        var bl:Int = b.length;
        if (al == 0 || bl == 0){ return null; }
        for (ia in 0...al){
            for (ib in 0...bl){
                for (ibn in 0...b[ib].length){
                    if (a[ia] == b[ib][ibn]) { rez.push([ia, ib, ibn]); }
                }
            }
        }return rez;
    }
    
    /**
     create chain from String Array. Sequences with same border values
     @param a - incoming array
     @param n - chain link length
     @param ring - if true then first incoming element will be added at the end of range, for the case of strict coincidence
    **/
    public static inline function chain_S(
        a:Array<String>,
        n:Int,
        ring:Bool = false
        ):Array<Array<String>>{
        var rez:Array<Array<String>> = null;
        var a_l:Int = a.length;
        if (n > a_l || n < 1){ return rez; }
        var ind:Array<Array<Int>> = NM.chain_indexes(a_l, n, ring);
        rez = [for (i in 0...ind.length) [for (j in 0...n) a[ind[i][j]]]];
        return rez;
    }
    /**
     create chain from Int Array. Sequences with same border values
     @param a - incoming array
     @param n - chain link length
     @param ring - if true then first incoming element will be added at the end of range, for the case of strict coincidence
    **/
    public static inline function chain_I(
        a:Array<Int>,
        n:Int,
        ring:Bool = false
        ):Array<Array<Int>>{
        var rez:Array<Array<Int>> = null;
        var a_l:Int = a.length;
        if (n > a_l || n < 1){ return rez; }
        var ind:Array<Array<Int>> = NM.chain_indexes(a_l, n, ring);
        rez = [for (i in 0...ind.length) [for (j in 0...n) a[ind[i][j]]]];
        return rez;
    }
    /**
     create chain from Float Array. Sequences with same border values
     @param a - incoming array
     @param n - chain link length
     @param ring - if true then first incoming element will be added at the end of range, for the case of strict coincidence
    **/
    public static inline function chain_F(
        a:Array<Float>,
        n:Int,
        ring:Bool = false
        ):Array<Array<Float>>{
        var rez:Array<Array<Float>> = null;
        var a_l:Int = a.length;
        if (n > a_l || n < 1){ return rez; }
        var ind:Array<Array<Int>> = NM.chain_indexes(a_l, n, ring);
        rez = [for (i in 0...ind.length) [for (j in 0...n) a[ind[i][j]]]];
        return rez;
    }
    
    /**
     return Float Array element with maximum absolute value with sign.
     Each element compared as abs(element). [1, 2, -4] return -4.
     @param a - incoming array
    **/
    public static function maxabs(a:Array<Float>):Float{
        var rez:Float = 0;
        for (i in a){if (Math.abs(i) > Math.abs(rez)){rez = i;}}
        return rez;
    }
    
}