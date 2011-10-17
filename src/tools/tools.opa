/*
 * (c) Valdabondance.com - 2011
 * @author Matthieu Guffroy - Thomas Recouvreux
 *
 */

package nostdlib.tools

Tools = {{

    list = {{
        replace(key : int, new_v : 'new_v, l : list('a)) : list('a) = 
            List.mapi((i,v -> if i==key then new_v else v), l)
    }}

    
    option = {{
        perform_default(f : ('o -> 'r), default : (->'r), o : option('o)) : 'r =
            match o with
            | {~some} -> f(some)
            | {none} -> default()
            end
    }}


}}
