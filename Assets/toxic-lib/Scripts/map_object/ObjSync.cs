using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjSync : MonoBehaviour
{
    Transform obj;
    bool inUP;
    // Start is called before the first frame update
    void Start()
    {
        if (obj.position.y > 0)
        {
            inUP = true;
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
