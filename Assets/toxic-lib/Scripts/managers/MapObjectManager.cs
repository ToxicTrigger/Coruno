using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapObjectManager : MonoBehaviour
{
    public Priority interActiveGameObject;
    public int bestPriority;
    // Start is called before the first frame update

    // Update is called once per frame
    void Update()
    {
        if (interActiveGameObject != null)
        {
            interActiveGameObject.isBestPriotity = true;
        }
    }

    public void Add(Priority obj)
    {
        if (interActiveGameObject == null)
        {
            interActiveGameObject  = obj;
        }
        else
        {
            if(interActiveGameObject.priotity >= obj.priotity)
            {
                interActiveGameObject.isBestPriotity = false;
                interActiveGameObject = obj;
            }
        }
    }

    public void Remove(Priority obj)
    {
        if (interActiveGameObject == null) return;

        if(interActiveGameObject == obj)
        {
            interActiveGameObject.isBestPriotity = false;
            interActiveGameObject = null;
        }
    }
}
