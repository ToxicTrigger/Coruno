using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class soda 
{
    public static void ReScaling(Transform target, Vector3 des, float speed)
    {
        int count = target.childCount;
        for(int i = 0; i < count; ++i)
        {
            var s = target.GetChild(i).localScale;
            target.GetChild(i).localScale = Vector3.MoveTowards(s, des, speed);
            
        }
    }
}
